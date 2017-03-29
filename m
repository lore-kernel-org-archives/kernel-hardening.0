References: <20170329203908.GA39222@beast>
 <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
 <CAGXu5jLQfS6gK2MyetWPjyJDOg8NdACXsPXLt7OasQE03VUwPg@mail.gmail.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <ca888ec2-e2e6-3600-3e39-c18e61e0c735@linux.intel.com>
Date: Wed, 29 Mar 2017 14:19:37 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLQfS6gK2MyetWPjyJDOg8NdACXsPXLt7OasQE03VUwPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/29/2017 02:09 PM, Kees Cook wrote:
> They're adjacent already, which poses a problem for the struct layout
> randomization plugin, since adjacency may no longer be true (after
> layout randomization). This adjacency (or not) isn't really the
> problem: it's that FPU state size is only known at runtime. Another
> solution would be to have FPU state be a fixed size...

We don't want that.  It varies from a couple hundred bytes to ~3k on
newer CPUs.  We don't want to eat an extra 2.5k per task on the older
processors.
