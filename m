Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Jul 2016 01:43:15 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160705014315.c44b7c41fcb6900e10d9f4a2@gmail.com>
In-Reply-To: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 3/3] Constify some function parameters
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

Initify needs const pointer types, the initify plugin caught some __printf
arguments that weren't const yet.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/isdn/hisax/config.c | 4 ++--
 drivers/isdn/hisax/hisax.h  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index bf04d2a..a7d53c9 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -659,7 +659,7 @@ int jiftime(char *s, long mark)
 
 static u_char tmpbuf[HISAX_STATUS_BUFSIZE];
 
-void VHiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt,
+void VHiSax_putstatus(struct IsdnCardState *cs, char *head, const char *fmt,
 		      va_list args)
 {
 	/* if head == NULL the fmt contains the full info */
@@ -729,7 +729,7 @@ void VHiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt,
 	}
 }
 
-void HiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt, ...)
+void HiSax_putstatus(struct IsdnCardState *cs, char *head, const char *fmt, ...)
 {
 	va_list args;
 
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 6ead6314..338d040 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -1288,9 +1288,9 @@ int jiftime(char *s, long mark);
 int HiSax_command(isdn_ctrl *ic);
 int HiSax_writebuf_skb(int id, int chan, int ack, struct sk_buff *skb);
 __printf(3, 4)
-void HiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt, ...);
+void HiSax_putstatus(struct IsdnCardState *cs, char *head, const char *fmt, ...);
 __printf(3, 0)
-void VHiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt, va_list args);
+void VHiSax_putstatus(struct IsdnCardState *cs, char *head, const char *fmt, va_list args);
 void HiSax_reportcard(int cardnr, int sel);
 int QuickHex(char *txt, u_char *p, int cnt);
 void LogFrame(struct IsdnCardState *cs, u_char *p, int size);
-- 
2.8.1
