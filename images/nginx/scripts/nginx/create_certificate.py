#! /usr/bin/python3

import argparse
import os
import time
from OpenSSL import crypto

def main():
    # parse arguments
    argparser = argparse.ArgumentParser(description="Create SSL Key/Certificate/CSR")
    argparser.add_argument("organisation", help="cert organisation")
    argparser.add_argument("unit", help="cert unit")
    argparser.add_argument("country", help="cert country")
    argparser.add_argument("state", help="cert state")
    argparser.add_argument("location", help="cert location")
    argparser.add_argument("cn", help="cert common name")
    argparser.add_argument("valid_time_days", help="cert valid time days")
    argparser.add_argument("keylength", help="cert key length")
    argparser.add_argument("digest", help="cert digest")
    argparser.add_argument("output_dir", help="directory for output of CSR, key and cert")
    arguments = argparser.parse_args()

    # create key
    ssl_key = crypto.PKey()
    ssl_key.generate_key(crypto.TYPE_RSA, int(arguments.keylength))

    # create csr
    ssl_csr = crypto.X509Req()
    ssl_csr.get_subject().C = arguments.country
    ssl_csr.get_subject().ST = arguments.state
    ssl_csr.get_subject().L = arguments.location
    ssl_csr.get_subject().O = arguments.organisation
    ssl_csr.get_subject().OU = arguments.unit
    ssl_csr.get_subject().CN = arguments.cn
    ssl_csr.set_pubkey(ssl_key)
    ssl_csr.sign(ssl_key, arguments.digest)

    # create self signed cert
    ssl_certificate = crypto.X509()
    ssl_certificate.get_subject().C = arguments.country
    ssl_certificate.get_subject().ST = arguments.state
    ssl_certificate.get_subject().L = arguments.location
    ssl_certificate.get_subject().O = arguments.organisation
    ssl_certificate.get_subject().OU = arguments.unit
    ssl_certificate.get_subject().CN = arguments.cn
    ssl_certificate.gmtime_adj_notBefore(0)
    ssl_certificate.gmtime_adj_notAfter(int(arguments.valid_time_days) * 24 * 60 * 60)
    ssl_certificate.set_pubkey(ssl_key)
    ssl_certificate.set_issuer(ssl_certificate.get_subject())
    ssl_certificate.set_serial_number(int(time.time()))
    ssl_certificate.sign(ssl_key, arguments.digest)

    # write output to files
    sslcsr_file_name = arguments.output_dir + "/proxy.csr"
    sslcert_file_name = arguments.output_dir + "/proxy.crt"
    sslkey_file_name = arguments.output_dir + "/proxy.key"
    with open(sslcsr_file_name, "wb") as sslcsr_file:
        sslcsr_file.write(crypto.dump_certificate_request(crypto.FILETYPE_PEM, ssl_csr))
    with open(sslcert_file_name, "wb") as sslcert_file:
        sslcert_file.write(crypto.dump_certificate(crypto.FILETYPE_PEM, ssl_certificate))
    with open(sslkey_file_name, "wb") as sslkey_file:
        sslkey_file.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, ssl_key))


if __name__  == "__main__":
    main()
