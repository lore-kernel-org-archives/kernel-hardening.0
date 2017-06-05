MIME-Version: 1.0
In-Reply-To: <20170605034757.4803-6-Jason@zx2c4.com>
References: <20170605034757.4803-1-Jason@zx2c4.com> <20170605034757.4803-6-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 01:18:01 +0200
Message-ID: <CAHmME9qWkYdrVCAUoDaQiJ4_56A9J5E=VK6iiTQVxvjNNEmQAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v2 5/8] security/keys: ensure RNG is seeded before use
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 5, 2017 at 5:47 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> -               get_random_bytes(&key->serial, sizeof(key->serial));
> +               ret = get_random_bytes_wait(&key->serial, sizeof(key->serial));

This actually isn't okay at bootup, but I've got a different change
for this section that will be in the v3.
