MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170212233140.10606-1-ewk@edkovsky.org>
References: <20170212233140.10606-1-ewk@edkovsky.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 10:16:14 -0800
Message-ID: <CAGXu5j+fkuY3VaGSXT3f9AygLzVzKdDSKjJsFvQrh=vF7wmWfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] [PATCH 0/2] provide check for ro_after_init memory sections
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 12, 2017 at 3:31 PM, Eddie Kovsky <ewk@edkovsky.org> wrote:
> Provide a mechansim for other functions to verify that their arguments
> are read-only. This implements the first half of a suggestion made by
> Kees Cook for the Kernel Self Protection Project:
>
>    * provide mechanism to check for ro_after_init memory areas, and
>      reject structures not marked ro_after_init in vmbus_register()
>
>      http://www.openwall.com/lists/kernel-hardening/2017/02/04/1

Awesome! I'd add the third patch too (to have vmbus_register() do the
check), just to have an example in the series.

> I have succesfully compiled this series on next-20170206 for x86. I am
> not sure how to go about testing these changes (perhpas with LKDTM?).

Hmm. LKDTM doesn't seem quite right since it's expecting to trip a
kernel self-protection check of some kind (and already has an
ro_after_init check). I think just adding users of this is a
sufficient test (i.e. vmbus_register()), since the ro_after_init
infrastructure is already being tested.

-Kees

-- 
Kees Cook
Pixel Security
