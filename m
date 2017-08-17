MIME-Version: 1.0
In-Reply-To: <20170816224650.1089-3-labbott@redhat.com>
References: <20170816224650.1089-1-labbott@redhat.com> <20170816224650.1089-3-labbott@redhat.com>
From: Nick Kralevich <nnk@google.com>
Date: Wed, 16 Aug 2017 21:56:15 -0700
Message-ID: <CAFJ0LnHdAwAHJipwqOHzdLktCL+Ttdywuogk0ORHqn7eauRLkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCHv2 2/2] extract early boot entropy from
 the passed cmdline
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, kernel-hardening@lists.openwall.com, lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 16, 2017 at 3:46 PM, Laura Abbott <labbott@redhat.com> wrote:
> From: Daniel Micay <danielmicay@gmail.com>
>
> Existing Android bootloaders usually pass data useful as early entropy
> on the kernel command-line. It may also be the case on other embedded
> systems. Sample command-line from a Google Pixel running CopperheadOS:
>

Why is it better to put this into the kernel, rather than just rely on
the existing userspace functionality which does exactly the same
thing? This is what Android already does today:
https://android-review.googlesource.com/198113

-- Nick
