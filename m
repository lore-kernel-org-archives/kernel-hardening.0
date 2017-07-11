References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <2b98d0c4-f40a-4407-47b8-611f12c2f96e@linux.com>
Date: Wed, 12 Jul 2017 01:56:42 +0300
MIME-Version: 1.0
In-Reply-To: <1499724283-30719-1-git-send-email-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 0/2] draft of stack clearing for arm64
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, pageexec@freemail.hu, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Laura,

On 11.07.2017 01:04, Laura Abbott wrote:
> I made an attempt at implementing stack clearing for arm64 using roughly
> the same algorithm as x86. It passes some level of basic tests but it definitely
> needs more careful review and thought ("submit early and often").

Thank you for joining that fun!

I will send the third version of the STACKLEAK patch shortly, please see the
changes. I'm going to CC x86@kernel.org. Hope they will have a look at the stack
erasing, and we will gain better understanding.

> As an added follow up, self-protection.rst should also be updated with some
> details about how stackleak actually works for people who want to follow on
> for other arches.

Thanks, I've added this to the TODO.

Best regards,
Alexander
