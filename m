Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 16 Jan 2017 20:30:29 +0100
MIME-Version: 1.0
Message-ID: <587D1F55.2222.8A262A4@pageexec.freemail.hu>
In-reply-to: <20170116152425.GG5908@leverpostej>
References: <20170113220256.GA57663@beast>, <5879F762.32059.37092152@pageexec.freemail.hu>, <20170116152425.GG5908@leverpostej>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 16 Jan 2017 at 15:24, Mark Rutland wrote:

> To me, it seems that the __user annotation can only be an indicator of
> an issue by chance. We have structures with __user pointers in structs
> that will never be copied to userspace, and conversely we have structs
> that don't contain a __user field, but will be copied to userspace.
> 
> Maybe it happens that structs in more complex systems are more likely to
> contain some __user pointer. Was that part of the rationale?

it's as i explained in an earlier email: we wanted to pattern match a
specific bug situation and this was the easiest way (as you can see,
the plugin's code is very simple, not much effort went into it).

> I wonder if there's any analysis we can do of data passing into
> copy_to_user() and friends. I guess we can't follow the data flow across
> compilation units, but we might be able to follow it well enough if we
> added a new attribute that described whether data was to be copied to
> userspace.

there're are all kinds of data flow analyses you can do within and even
across translation units (summary info a'la size overflow hash tables or
LTO). i never went into that direction because i think the security goal
can be achieved without the performance impact of forced initialization.
