References: <20171230175804.7354-1-alonid@gmail.com>
 <20171230175804.7354-5-alonid@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2bea24d0-5ae9-7614-43ba-45674785e8e2@infradead.org>
Date: Sat, 30 Dec 2017 12:20:40 -0800
MIME-Version: 1.0
In-Reply-To: <20171230175804.7354-5-alonid@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/5] tools: add dmesg decryption program
To: Dan Aloni <dan@kernelim.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/30/2017 09:58 AM, Dan Aloni wrote:
> From: Dan Aloni <dan@kernelim.com>
> 
> Example execution:
> 
>     dmesg | dmesg-decipher <private-key.pem>
> 
> Signed-off-by: Dan Aloni <dan@kernelim.com>
> ---


> diff --git a/tools/kmsg/dmesg-decipher.c b/tools/kmsg/dmesg-decipher.c
> new file mode 100644
> index 000000000000..c7149fe7dc17
> --- /dev/null
> +++ b/tools/kmsg/dmesg-decipher.c
> @@ -0,0 +1,316 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * dmesg-decipher.c
> + *
> + * A sample utility to decrypt an encrypted dmesg output, for
> + * developement with kernels having kmsg encryption enabled.
> + *
> + * Copyright (c) Dan Aloni, 2017
> + *
> + * Compile with
> + *	gcc -I/usr/src/linux/include getdelays.c -o getdelays

	copy-paste error ^^^

> + */
> +
> +#include <openssl/pem.h>
> +#include <openssl/pkcs7.h>
> +#include <openssl/err.h>
> +
> +#include <stdbool.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <regex.h>


[snip]


> +int main(int argc, char **argv)
> +{
> +	BIO *tbio = NULL;
> +	RSA *rsa;
> +	int ret = 1;
> +	char line[0x1000];
> +	uint8_t enc_sess_key[0x200];
> +	uint8_t sess_key[0x200] = {0, };
> +	bool got_key = false;
> +
> +	OpenSSL_add_all_algorithms();
> +	ERR_load_crypto_strings();
> +
> +	regex_t session_key_regex;
> +	regex_t message_regex;
> +
> +	ret = regcomp(&session_key_regex, session_key_pattern, REG_EXTENDED);
> +	if (ret) {
> +		goto err;
> +	}
> +
> +	ret = regcomp(&message_regex, message_pattern, REG_EXTENDED);
> +	if (ret) {
> +		goto err;
> +	}
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "not enough paramters\n");

		                            parameters

> +		return -1;
> +	}


-- 
~Randy
