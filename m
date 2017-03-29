MIME-Version: 1.0
In-Reply-To: <CA+55aFxGEQroSYmSgEQefNUhJfmvMRg8XAy3TrtYoiLwUQNwKA@mail.gmail.com>
References: <20170329203908.GA39222@beast> <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
 <CAGXu5jLQfS6gK2MyetWPjyJDOg8NdACXsPXLt7OasQE03VUwPg@mail.gmail.com> <CA+55aFxGEQroSYmSgEQefNUhJfmvMRg8XAy3TrtYoiLwUQNwKA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Mar 2017 14:35:16 -0700
Message-ID: <CALCETrVudF5-buAHqGd3y1g8X3mnf6tmB5Av50k9WFL-yrbZmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 2:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 29, 2017 at 2:09 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> They're adjacent already, which poses a problem for the struct layout
>> randomization plugin, since adjacency may no longer be true (after
>> layout randomization). T
>
> What?
>
> The layout randomization can't change anything, if you just make the
> adjacency be done explicitly instead of by having the thing be a fixed
> member.
>
> The trivial model might be to just declare the fpu part as an unsized
> array at the end:
>
>         /* Floating point and extended processor state */
>         struct fpu              fpu[];
>
> because there is no way in hell that any randomization code can move
> those kinds of unsized arrays around. If it does, the gcc plugin is
> such unbelievable garbage that it would be insane to depend on such
> shit in the first place.
>

Randomization also needs to leave thread_info at the beginning.  Can it do that?
