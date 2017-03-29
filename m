MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrVudF5-buAHqGd3y1g8X3mnf6tmB5Av50k9WFL-yrbZmQ@mail.gmail.com>
References: <20170329203908.GA39222@beast> <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
 <CAGXu5jLQfS6gK2MyetWPjyJDOg8NdACXsPXLt7OasQE03VUwPg@mail.gmail.com>
 <CA+55aFxGEQroSYmSgEQefNUhJfmvMRg8XAy3TrtYoiLwUQNwKA@mail.gmail.com> <CALCETrVudF5-buAHqGd3y1g8X3mnf6tmB5Av50k9WFL-yrbZmQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Mar 2017 14:41:00 -0700
Message-ID: <CA+55aFyVxvzyHxAx4Wik=FtKLJLFxa12kbuS+3KatLU+ysM7Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 2:35 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Randomization also needs to leave thread_info at the beginning.  Can it do that?

Good point, and good question. No idea if the gcc extension can do,
but yes, it clearly needs a "you can't move this entry".

I assume it has some such capability already, because it's fairly
common to have that kind of "beginning of structure if fixed" due to
unions of structures anyway.

                 Linus
