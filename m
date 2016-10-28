Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 28 Oct 2016 18:27:09 +0100
Message-Id: <1477675636-3957-2-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
References: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v4 1/8] arm64: Update the synchronous external abort fault description
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Sami Tolvanen <samitolvanen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch updates the description of the synchronous external aborts on
translation table walks.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/mm/fault.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0f8788374815..d035cc594445 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -507,10 +507,10 @@ static const struct fault_info {
 	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
-	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
+	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
 	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
 	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
 	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
