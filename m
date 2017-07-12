References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
 <1499724283-30719-3-git-send-email-labbott@redhat.com>
 <20170711195154.GA7124@leverpostej>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <fb9f92d2-6737-d9ae-ed49-fa61a089c727@linux.com>
Date: Wed, 12 Jul 2017 09:01:04 +0300
MIME-Version: 1.0
In-Reply-To: <20170711195154.GA7124@leverpostej>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 2/2] arm64: Clear the stack
To: Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Mark,

On 11.07.2017 22:51, Mark Rutland wrote:
> On Mon, Jul 10, 2017 at 03:04:43PM -0700, Laura Abbott wrote:
>> - Where else do we need to clear the stack?
> 
> I guess we might need to clear (all of the remainder of) the stack after
> invoking EFI runtime services -- those can run in task context, might
> leave sensitive values on the stack, and they're uninstrumented. The
> same would apply for x86.

Thanks, I've added this to the TODO list.

> I think we can ignore garbage left on the stack by idle/hotplug, since
> that happens in the idle thread, so we shouldn't be doing uaccess
> transfers on those stacks.

Excuse me, I didn't understand what you mean. erase_kstack() is called at the
end of syscall before returning to the userspace.

Best regards,
Alexander
