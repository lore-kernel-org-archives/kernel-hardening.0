Return-Path: <kernel-hardening-return-21647-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E51F1C76196
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Apr 2023 14:08:43 +0000 (UTC)
Received: (qmail 1538 invoked by uid 550); 2 Apr 2023 14:08:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1502 invoked from network); 2 Apr 2023 14:08:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hboeck.de; s=key1;
	t=1680444497; bh=hK2aXaDCND0vx9D3Ib9s+nTMgP5R7OwTJspfW/dzuG0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	b=U3hrOt2gcW+MbTMENq+AmhjGHD9W7ETMIppOOJhwlUL3UuQe96tB6MMlyCwuqBlRz
	 65DRLP3z1OD42jfVj8UHYbKpa8lpQ/oUy4VHsrI9pSLJmvEIvCpfXXz3THJd7lkMis
	 X4zUVMkM2jIaHsOypDleoELCK51h4hgC0YTRfSBQQQNzAxN8Pk0jkoOZIP+C1OQ6gX
	 OZzU0L7graTpWwuRb/B/D+bQ21zGYEbxQlOVFrdfVCl0dLYh1y8g+buyArm927goHz
	 Mf5QtnYAiOUZeHPXtBD0rWmSq4RJfw+2ntX2lOGH9q4nlIJb4RrCSwCOgguiKf4as7
	 ZFtYzEg/CmBFw==
Original-Subject: [PATCH] Restrict access to TIOCLINUX
Author: Hanno =?iso-8859-1?q?B=F6ck?= <hanno@hboeck.de>
Date: Sun, 2 Apr 2023 16:08:15 +0200
From: Hanno =?iso-8859-1?q?B=F6ck?= <hanno@hboeck.de>
To: kernel-hardening@lists.openwall.com
Subject: [PATCH] Restrict access to TIOCLINUX
Message-ID: <20230402160815.74760f87.hanno@hboeck.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm sending this here before I'll try to send it to lkml and the
respective maintainers to get some feedback first.

The TIOCLINUX functionality in the kernel can be abused for privilege
escalation, similar to TIOCSTI. I considered a few options how to fix
this, and this is what I came up with.


Restrict access to TIOCLINUX

TIOCLINUX can be used for privilege escalation on virtual terminals when
code is executed via tools like su/sudo.
By abusing the selection features a lower-privileged application can
write content to the console, select and copy/paste that content and
thereby executing code on the privileged account. See also the poc here:
  https://www.openwall.com/lists/oss-security/2023/03/14/3

Selection is usually used by tools like gpm that provide mouse features
on the virtual console. gpm already runs as root (due to earlier
changes that restrict access to a user on the current tty), therefore
it will still work with this change.

The security problem mitigated is similar to the security risks caused
by TIOCSTI, which, since kernel 6.2, can be disabled with
CONFIG_LEGACY_TIOCSTI=3Dn.

Signed-off-by: Hanno B=C3=B6ck <hanno@hboeck.de>
---
 drivers/tty/vt/vt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3c2ea9c098f7..3671173109b8 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3146,10 +3146,14 @@ int tioclinux(struct tty_struct *tty, unsigned
long arg) switch (type)
 	{
 		case TIOCL_SETSEL:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
 			ret =3D set_selection_user((struct
tiocl_selection __user *)(p+1), tty);
 			break;
 		case TIOCL_PASTESEL:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
 			ret =3D paste_selection(tty);
 			break;
 		case TIOCL_UNBLANKSCREEN:
@@ -3158,6 +3162,8 @@ int tioclinux(struct tty_struct *tty, unsigned
long arg) console_unlock();
 			break;
 		case TIOCL_SELLOADLUT:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
 			console_lock();
 			ret =3D sel_loadlut(p);
 			console_unlock();
--=20
2.40.0

--=20
Hanno B=C3=B6ck
https://hboeck.de/
