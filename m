Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  3 Oct 2013 13:53:18 -0700
Message-Id: <1380833605-26313-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 0/7] Kernel base address randomization on x86
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Updated from v6 with some suggestions from HPA.

As before, this detects and uses various available randomness sources to
choose an available slot from the e820 regions for kernel base address
relocation.

This is rolled out on Chrome OS devices, and working well.

-Kees
