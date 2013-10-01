Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  1 Oct 2013 12:37:18 -0700
Message-Id: <1380656245-29975-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 0/7] Kernel base address randomization
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Here is the latest version of the kASLR series. It has much improved
e820 walking code, and expands the window available on 64-bit.

This is rolled out on Chrome OS devices, and working well.

-Kees
