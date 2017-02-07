Message-ID: <58999F15.3090807@arm.com>
Date: Tue, 07 Feb 2017 10:19:01 +0000
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <1486296850-16045-1-git-send-email-kpark3469@gmail.com> <1486296850-16045-2-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1486296850-16045-2-git-send-email-kpark3469@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/3] arm64: usercopy: Implement stack frame object
 validation
To: kpark3469@gmail.com
Cc: kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On 05/02/17 12:14, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
> 
> This implements arch_within_stack_frames() for arm64 that should
> validate if a given object is contained by a kernel stack frame.
> 
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>

> Reviewed-by: James Morse <james.morse@arm.com>

Careful, you should only include tags like this when they are explicitly given.
I don't remember doing that, and don't see it here:
http://www.openwall.com/lists/kernel-hardening/2017/01/26/8

I'd like to avoid having two sets of code that walk the stack.
I will have a go at a version of this patch that uses arm64s existing
walk_stackframe() machinery - lets find out if there is a good reason not to do
it that way!


Thanks,

James
