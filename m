MIME-Version: 1.0
In-Reply-To: <15666.1496774756@warthog.procyon.org.uk>
References: <20170606173900.29279-1-Jason@zx2c4.com> <14825.1496771896@warthog.procyon.org.uk>
 <CAHmME9q35r302wJm_Y+UD1nT-fXcs9VGaDrZ5xWOm4jzDgyFwQ@mail.gmail.com> <15666.1496774756@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 21:18:15 +0200
Message-ID: <CAHmME9odRhCDMp7BYrhBwY+yc5av3WBb+EzTfVQtBGg5eWSoDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] security/keys: rewrite all of big_key crypto
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 8:45 PM, David Howells <dhowells@redhat.com> wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
>> Thank you! Perfect instructions, I'll play around with this and make
>> sure it works.
>
> Don't forget that it's bimodal.  You need to give it sufficient data to
> trigger storage in swappable space.

Somewhat incredibly, it works perfectly.

First I tried the instructions you noted, and things worked, both for
big files and small ones.

Then I modified the source to print to dmesg the data buffer and the
key before and after the encryption/decryption function. I verified
with a small python script that indeed standard aes-gcm is being used
successfully.

Thus, pending Ted's approval of the new random API, this patch should
be ready for merging.

Regards,
Jason
