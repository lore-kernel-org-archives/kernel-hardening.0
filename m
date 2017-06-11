MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <878tkzq6wi.fsf@purkki.adurom.net>
References: <20170610025912.6499-1-Jason@zx2c4.com> <878tkzq6wi.fsf@purkki.adurom.net>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 11 Jun 2017 06:36:27 -0700
Message-ID: <CAGXu5jKp=X7-eKo+HgzS3uqncx5yy-u=tJNqV9K8GOgJ=-C7iA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/6] Constant Time Memory Comparisons Are Important
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Anna Schumaker <anna.schumaker@netapp.com>, David Howells <dhowells@redhat.com>, David Safford <safford@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, Gilad Ben-Yossef <gilad@benyossef.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gustavo Padovan <gustavo@padovan.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Johan Hedberg <johan.hedberg@gmail.com>, Johannes Berg <johannes@sipsolutions.net>, Marcel Holtmann <marcel@holtmann.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Trond Myklebust <trond.myklebust@primarydata.com>, keyrings@vger.kernel.org, linux-bluetooth@vger.kernel.org, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, linux-wireless <linux-wireless@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 11, 2017 at 1:13 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
>> Whenever you're comparing two MACs, it's important to do this using
>> crypto_memneq instead of memcmp. With memcmp, you leak timing information,
>> which could then be used to iteratively forge a MAC.
>
> Do you have any pointers where I could learn more about this?

While not using C specifically, this talks about the problem generally:
https://www.chosenplaintext.ca/articles/beginners-guide-constant-time-cryptography.html

-Kees

-- 
Kees Cook
Pixel Security
