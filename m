Reply-To: kernel-hardening@lists.openwall.com
References: <cover.1468270393.git.luto@kernel.org>
 <3213d3f31959a6467b1feb80a384c1e11341b2be.1468270393.git.luto@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57852E3D.6010107@intel.com>
Date: Tue, 12 Jul 2016 10:51:57 -0700
MIME-Version: 1.0
In-Reply-To: <3213d3f31959a6467b1feb80a384c1e11341b2be.1468270393.git.luto@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v5 13/32] x86/mm/64: In
 vmalloc_fault(), use CR3 instead of current->active_mm
To: kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/11/2016 01:53 PM, Andy Lutomirski wrote:
> If we get a vmalloc fault while current->active_mm->pgd doesn't
> match CR3, we'll crash without this change.  I've seen this failure
> mode on heavily instrumented kernels with virtually mapped stacks.

When does this happen, btw?  Crossing page boundaries on the stack
between the time we swap mm's and the time we switch stacks?
