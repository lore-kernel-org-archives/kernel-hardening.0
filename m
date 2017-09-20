From: Stephan Mueller <smueller@chronox.de>
Date: Wed, 20 Sep 2017 07:30:56 +0200
Message-ID: <1593673.B5xods8kYN@tauon.chronox.de>
In-Reply-To: <20170917115217.15805-1-Jason@zx2c4.com>
References: <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com> <20170917115217.15805-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH v6] security/keys: rewrite all of big_key crypto
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, dhowells@redhat.com, ebiggers3@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Am Sonntag, 17. September 2017, 13:52:17 CEST schrieb Jason A. Donenfeld:

Hi Jason,

>   * Use of ECB mode, allowing an attacker to trivially swap blocks or
>     compare identical plaintext blocks.

The use of GCM with the implementtion here is just as challenging. The 
implementation uses a NULL IV. GCM is a very brittle cipher where the 
construction of the IV is of special importance. SP800-38D section 8.2.1 and 
8.2.2 outlines the generation methods of the IV. A collision of keys/IVs is 
fatal. I understand that keys are generated anew each time which makes that 
issue less critical here. However, as user space may see the ciphertext, GCM 
should simply not be used.

A fix could be as easy as to use CCM or one of the authenc() ciphers. Yet, for 
both I am not sure how a zero IV affects the cipher.

The cipher where you do not need to handle the IV at all would be the RFC3394/
SP800-38F keywrapping cipher which is meant for the encryption of key material 
which includes authentication as well. It is available as an skcipher under 
the name of kw(aes). If you want to use it, please be careful that you obtain 
the generated IV to be stored with the plaintext as documented in the comments 
in crypto/keywrap.c


Ciao
Stephan
