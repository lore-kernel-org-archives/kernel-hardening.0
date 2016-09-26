Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160912065318.GH16712@linaro.org>
References: <20160912065318.GH16712@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 26 Sep 2016 10:17:15 -0700
Message-ID: <CAGXu5jL+WXojAYeZB6KWCjXH_L6WnzN9m6kjVy6Lng_yYUzy4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Self introduction
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Sep 11, 2016 at 11:53 PM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> Hi Kees and all,

Hi! Sorry for not replying sooner -- this email seemed to strangely
not make its way into the kernel-hardening list, even though it looks
from the headers like you sent it there. Regardless, on to my late
reply...

> I'm looking for any tasks that I could contribute in
> kernel-hardening areas. As I'm working for Linaro,
> arm/arm64-related items (or arch-specific implementation
> of more generic features) would be better fitted, but I'm
> open to broader topics, including complementary tasks
> for other guys.

Awesome! Yeah, it'll be great to have you helping. Are there any areas
you especially enjoy working on?

> Do you have any suggestions about such items for me
> to start small (or can be even big :) with?

I think a great area would be looking at arm and arm64 support for
catching atomic_t wrap-around. This kind of protection would have
stopped many of the public attacks from last year, since accidents
with refcounting on atomic_t tend to be a precursor to use-after-free
vulnerabilities.

This idea has been implemented in PaX/Grsecurity for a while now as
PAX_REFCOUNT. An earlier effort to extract it was started but he ran
out of time to work on it. Recently the folks from Intel have been
looking at the x86 side of this (and took on the burden of preparing
the upstreaming of the marking of the expected-wrap uses in the
kernel), but we'll still need other architectures to support this
feature. There's an excellent write-up on the feature here:
https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
There isn't yet an implementation for arm64 (though maybe it'll be
identical/similar to the existing arm implementation).

I think Intel will be posting an RFC series soonish, which would
likely be the right place to start from.

-Kees

-- 
Kees Cook
Nexus Security
