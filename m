MIME-Version: 1.0
References: <20190220005449.GA25243@beast> <CAG48ez3Kbt7oyH7wyw+d1vwNRD_b5Y+tiCOLofkxyqxcNWs8vw@mail.gmail.com>
In-Reply-To: <CAG48ez3Kbt7oyH7wyw+d1vwNRD_b5Y+tiCOLofkxyqxcNWs8vw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 09:00:45 -0800
Message-ID: <CAGXu5j+5rfZ17KcBwMPg6dEnBBVZVvFjv+xZhyThr2rJZ-V0WA@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: Pin sensitive CR4 bits
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 6:37 PM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Feb 20, 2019 at 1:55 AM Kees Cook <keescook@chromium.org> wrote:
> > +       if (WARN_ONCE(cr4_pin && (val & cr4_pin) == 0,
>
> Don't you mean `cr4_pin && (val & cr4_pin) != cr4_pin)`?

Whoops! Yes, thanks. :)

-- 
Kees Cook
