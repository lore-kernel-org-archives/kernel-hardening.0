References: <20170329203908.GA39222@beast>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
Date: Wed, 29 Mar 2017 13:45:32 -0700
MIME-Version: 1.0
In-Reply-To: <20170329203908.GA39222@beast>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 03/29/17 13:39, Kees Cook wrote:
> This removes ARCH_WANTS_DYNAMIC_TASK_STRUCT from x86, leaving only s390
> still defining this config.
> 
> In order to support future structure layout randomization of the
> task_struct, none of the structure fields are allowed to have a specific
> position or dynamic size. To enable randomization of task_struct on
> x86, the FPU state must be moved to its own dynamically sized cache,
> and dereferenced from the task_struct.
> 
> This change is nearly identical to what was done in grsecurity to support
> structure layout randomization. Hopefully I found all the needed changes.
> This passes allyesconfig, and boot tests.

Is this really what we want to happen?  It seems much more sane to
simply make them adjacent; they don't need to be part of the same
structure (in practice, there are three objects: thread_info,
task_struct, and the FPU state.)

	-hpa
