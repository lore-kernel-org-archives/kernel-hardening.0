MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
References: <20170329203908.GA39222@beast> <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 14:09:15 -0700
Message-ID: <CAGXu5jLQfS6gK2MyetWPjyJDOg8NdACXsPXLt7OasQE03VUwPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 1:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/29/17 13:39, Kees Cook wrote:
>> This removes ARCH_WANTS_DYNAMIC_TASK_STRUCT from x86, leaving only s390
>> still defining this config.
>>
>> In order to support future structure layout randomization of the
>> task_struct, none of the structure fields are allowed to have a specific
>> position or dynamic size. To enable randomization of task_struct on
>> x86, the FPU state must be moved to its own dynamically sized cache,
>> and dereferenced from the task_struct.
>>
>> This change is nearly identical to what was done in grsecurity to support
>> structure layout randomization. Hopefully I found all the needed changes.
>> This passes allyesconfig, and boot tests.
>
> Is this really what we want to happen?  It seems much more sane to
> simply make them adjacent; they don't need to be part of the same
> structure (in practice, there are three objects: thread_info,
> task_struct, and the FPU state.)

They're adjacent already, which poses a problem for the struct layout
randomization plugin, since adjacency may no longer be true (after
layout randomization). This adjacency (or not) isn't really the
problem: it's that FPU state size is only known at runtime. Another
solution would be to have FPU state be a fixed size...

-Kees

-- 
Kees Cook
Pixel Security
