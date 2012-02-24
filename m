Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 24 Feb 2012 23:59:47 +0200
MIME-Version: 1.0
Reply-to: pageexec@freemail.hu
Message-ID: <4F481663.5371.216F475B@pageexec.freemail.hu>
In-reply-to: <20120224191300.GA12553@albatros>
References: <20120217075945.GA2831@albatros>, <20120224190549.GA8034@elliptictech.com>, <20120224191300.GA12553@albatros>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Nick Bowler <nbowler@elliptictech.com>, Vasiliy Kulikov <segoon@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dwindsor@gmail.com>, Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>, kernel-hardening@lists.openwall.com, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 24 Feb 2012 at 23:13, Vasiliy Kulikov wrote:

> > But in this case, the principle does not apply because we can recover.
> > The reason we cannot recover from the stack protector case is because
> > the stack protector is reacting after the fact, which is not the case
> > here.  Simply peg the reference count at the maximum value, neither
> > incrementing it nor decrementing it further.
> 
> ...and simply loose one reference, which leads to use-after-free.

saturating the refcount keeps the protected object allocated, so it is
a memory leak, but it is not a use-after-free.
