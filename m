MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180629190553.7282-1-labbott@redhat.com>
References: <20180629190553.7282-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 29 Jun 2018 12:47:03 -0700
Message-ID: <CAGXu5jK+nqbRnk=RQW0wPrcEjqvmuR3dWKxyaXqXHn9__Kx0EA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Clear the stack
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 29, 2018 at 12:05 PM, Laura Abbott <labbott@redhat.com> wrote:
> Implementation of stackleak based heavily on the x86 version

Awesome!

Now I just have to figure out how to unbreak cross-compilation after
the kconfig changes to gcc-plugins. Whoops. :)

-Kees

-- 
Kees Cook
Pixel Security
