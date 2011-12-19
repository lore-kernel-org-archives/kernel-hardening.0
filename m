Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Dec 2011 14:17:44 -0800
Message-Id: <1324333066-12452-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v9 0/2] security: Yama LSM
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

As discussed at the Linux Security Summit, I'm resubmitting this
code. As an LSM, it has coherent policy around expanding specific DAC
behaviors. There is no need for it to be a full-blown MAC, since it is
not intended to be one, but rather to be a simplified expansion to DAC,
with system-wide knobs. See the specific patches for details...

This version only contains the ptrace restrictions, since a path has
been cleared for that (thanks Roland). The link restriction discussion
can continue separately. In the meantime, I will carry it as a patch here:
http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/yama

Thanks,

-Kees
