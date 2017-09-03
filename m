From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun,  3 Sep 2017 13:07:29 +0100
Message-Id: <20170903120757.14968-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 01/29] net/core: work around section mismatch warning for ptp_classifier
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

The routine ptp_classifier_init() uses an initializer for an
automatic struct type variable which refers to an __initdata
symbol. This is perfectly legal, but may trigger a section
mismatch warning when running the compiler in -fpic mode, due
to the fact that the initializer may be emitted into an anonymous
.data section thats lack the __init annotation. So work around it
by using assignments instead.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 net/core/ptp_classifier.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/ptp_classifier.c b/net/core/ptp_classifier.c
index 703cf76aa7c2..7109c168b5e0 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -185,9 +185,10 @@ void __init ptp_classifier_init(void)
 		{ 0x16,  0,  0, 0x00000000 },
 		{ 0x06,  0,  0, 0x00000000 },
 	};
-	struct sock_fprog_kern ptp_prog = {
-		.len = ARRAY_SIZE(ptp_filter), .filter = ptp_filter,
-	};
+	struct sock_fprog_kern ptp_prog;
+
+	ptp_prog.len = ARRAY_SIZE(ptp_filter);
+	ptp_prog.filter = ptp_filter;
 
 	BUG_ON(bpf_prog_create(&ptp_insns, &ptp_prog));
 }
-- 
2.11.0
