Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 23 Jul 2011 13:35:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110723093543.GA3908@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] PAX_MPROTECT mechanism
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar, all -

This is a summary of PAX_MPROTECT actions and limitations.

Solar, please review the scheme and say whether it should be
relaxed/restricted or whether it makes sense to push it upstream at all.


* Stack is created with cleared VM_MAYEXEC => cannot be made exec in future.

* mmap() with (VM_WRITE | VM_EXEC) flags are denied.  If
CONFIG_PAX_MPROTECT_COMPAT=y then VM_EXEC is just cleared.
(If clamav detects NX while mapping a page for JIT, it fallbacks to
interpreter based mode.  Other programs might not detect it :( )

* If mmap() doesn't define VM_EXEC then VM_MAYEXEC is cleared (the page cannot
be made exec in the future), otherwise VM_MAYWRITE is cleared.

* brk() pages are created with cleared VM_MAYEXEC even when personality
READ_IMPLIES_EXEC is set.

* After RELRO ELF section is altered, it clears VM_MAYWRITE on the section.


So, with there restrictions there are no WX pages and there are 2 ways to
introduce new code in the task vm:

1) mmap with VM_EXEC pre-created file with attacker's code.

2) execve attacker's / system binary.

As PaX documentation says, both should be denied with some sandboxing
mechanism like RBAC/SELinux/etc.


In PaX there restrictions can be disabled per binary.  To do it in the
mainline kernel the toolchain should be patched :)

I'm afraid of stack restriction - it contradicts GNU_STACK policy.  Also
if GNU_STACK is still handled, it should be fully handled in kernel as
userspace hasn't got power to re-enable X.  So, before pushing it
upstream GNU_STACK problem might be necessarily resolved.

Thanks,

-- 
Vasiliy
