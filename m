Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Oct 2013 17:18:12 -0700
Message-Id: <1381450698-28710-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v8 0/6] Kernel base address randomization
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Update to the kASLR series. The improved e820 walking code from v7 has been
reorganized, and now explicitly avoids unsafe memory regions instead of
raising the minimum load address.

-Kees
