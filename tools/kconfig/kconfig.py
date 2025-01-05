import os
import sys
from kconfiglib import Kconfig


def generate_config(kconfig_file, config_in, config_out, header_out):
    kconf = Kconfig(kconfig_file)

    # Load config files(.config exists)
    if os.path.isfile(config_in):
        print(kconf.load_config(config_in))

    # Write merged config
    print(kconf.write_config(config_out))

    # Write headers
    print(kconf.write_autoconf(header_out))

    with open(header_out, 'r+') as header_file:
        content = header_file.read()
        header_file.truncate(0)
        header_file.seek(0)

        # Remove CONFIG_ and MR_USING_XXX following number
        # content = content.replace("#define CONFIG_", "#define ")

        # Add the micro
        header_file.write("#ifndef __CONFIG_H__\r\n")
        header_file.write("#define __CONFIG_H__\r\n\r\n")

        header_file.write("#ifdef __cplusplus\r\n")
        header_file.write("extern \"C\" {\n")
        header_file.write("#endif\r\n\r\n")

        # Write back the original data
        header_file.write(content)

        # Add the micro
        header_file.write("\r\n#ifdef __cplusplus\r\n")
        header_file.write("}\r\n")
        header_file.write("#endif\r\n\r\n")
        header_file.write("#endif\r\n")


def main(argc: int, argv: list[str]):
    kconfig_file = argv[1] if argc > 1 else 'Kconfig'
    config_in = argv[2] if argc > 2 else '.config'
    config_out = argv[3] if argc > 3 else '.config'
    header_out = argv[4] if argc > 4 else 'build/config.h'

    generate_config(kconfig_file, config_in, config_out, header_out)


if __name__ == "__main__":
    main(len(sys.argv), sys.argv)
