Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 3 Jul 2016 11:40:38 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160703094038.GA1781@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org>
 <37ac7589ff0ea147e8a21cda5eb84d3af1f6cd60.1466974736.git.luto@kernel.org>
 <20160702172441.GA22748@pd.tnic>
 <20160702183451.e2nlfkfxlsuicbqd@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20160702183451.e2nlfkfxlsuicbqd@treble>
Subject: [kernel-hardening] Re: [PATCH v4 10/29] x86/die: Don't try to recover from an OOPS on a
 non-default stack
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jul 02, 2016 at 01:34:51PM -0500, Josh Poimboeuf wrote:
> The existing 'object_is_on_stack()' can probably be used:
> 
> 	if (!object_is_on_stack(current_top_of_stack()))
> 		panic("...");
> 
> Though that function isn't quite accurately named.  It should really
> have 'task_stack' in its name, like 'object_is_on_task_stack()'.  Or
> even better, something more concise like 'on_task_stack()'.

So I'm obviously missing something here:

object_is_on_stack() uses task_stack_page(current) -> task_struct.stack
while current_stack_pointer() reads %rsp directly.

I'm guessing %rsp and task_struct.stack are in sync?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
