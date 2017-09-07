MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170907072029.GA15056@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-8-git-send-email-keescook@chromium.org> <20170528081249.GD22193@infradead.org>
 <CAGXu5j+LSrLzZSWLozjGvjEQV6P-Mgsj9Fgdp9wuiFxV=JrYgA@mail.gmail.com>
 <CAGXu5jKxFZ17-XuFDxz=qr9o_7KXLg2dh_krN=OQQ+1bFP=qqw@mail.gmail.com> <20170907072029.GA15056@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 7 Sep 2017 15:55:17 -0700
Message-ID: <CAGXu5jL00+BgNe7KJYXMBFNFg-qaNgkZyL2HAT5zzwRawFY6jg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 07/20] randstruct: Whitelist big_key path struct overloading
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 7, 2017 at 12:20 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 19, 2017 at 12:24:13PM -0700, Kees Cook wrote:
>> David, if you can Ack this, I'll carry it in my tree.
>
> This didn't seem to make it anywhere and we got the sad blacklist
> entry instead..

David, thoughts? It seems like a nice solution. If you don't object, I
could carry it in -next (and remove the randstruct whitelist entry)?

-Kees

-- 
Kees Cook
Pixel Security
