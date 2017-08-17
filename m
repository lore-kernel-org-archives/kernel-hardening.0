MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAFJ0LnHdAwAHJipwqOHzdLktCL+Ttdywuogk0ORHqn7eauRLkA@mail.gmail.com>
References: <20170816224650.1089-1-labbott@redhat.com> <20170816224650.1089-3-labbott@redhat.com>
 <CAFJ0LnHdAwAHJipwqOHzdLktCL+Ttdywuogk0ORHqn7eauRLkA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 16 Aug 2017 21:58:26 -0700
Message-ID: <CAGXu5jLyegoCA4cBDyOWvcsV3_wE8BBFRnuhkbORdFHTswGpoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCHv2 2/2] extract early boot entropy from
 the passed cmdline
To: Nick Kralevich <nnk@google.com>
Cc: Laura Abbott <labbott@redhat.com>, Daniel Micay <danielmicay@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, lkml <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 16, 2017 at 9:56 PM, Nick Kralevich <nnk@google.com> wrote:
> On Wed, Aug 16, 2017 at 3:46 PM, Laura Abbott <labbott@redhat.com> wrote:
>> From: Daniel Micay <danielmicay@gmail.com>
>>
>> Existing Android bootloaders usually pass data useful as early entropy
>> on the kernel command-line. It may also be the case on other embedded
>> systems. Sample command-line from a Google Pixel running CopperheadOS:
>>
>
> Why is it better to put this into the kernel, rather than just rely on
> the existing userspace functionality which does exactly the same
> thing? This is what Android already does today:
> https://android-review.googlesource.com/198113

That's too late for setting up the kernel stack canary, among other
things. The kernel will also be generating some early secrets for slab
cache canaries, etc. That all needs to happen well before init is
started.

-Kees

-- 
Kees Cook
Pixel Security
