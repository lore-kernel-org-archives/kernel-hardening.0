Return-Path: <kernel-hardening-return-21683-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 10423C71153
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 12:22:09 +0000 (UTC)
Received: (qmail 4004 invoked by uid 550); 28 Aug 2023 12:21:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3968 invoked from network); 28 Aug 2023 12:21:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693225307; x=1693830107;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6znZ4h/bFO0y4zxr99DQkfyX6CJsaAjv1JSqCiqfzY=;
        b=tcDFddHMmh+M9w5NEw8wAOXudh9wwAmq46gwowxIV+qv6GyW/K/e56imKh+NXYRBqC
         eXT4EL4UqWOWnf7cPw1Z6X2jl69QN3SZ/zkuVszhjtKaEB71vWtJ6ALRXd9kxr9YQpDg
         55MNNACAfc9BFVpdSMJTcVhogfIMD/wkRf60fBEmLro4fUS981CdvMzWk42K3UVsZZBL
         XzgD0FXYWQWDjQ1z2AL+k+oJ+0W2gVXZeJUzF7hBpb3oF1AJTQF5PIm0PVsuYvYAncsG
         Cc63EkCA9GLX8s6PNpyTDylfrbIZHgE+s0OLzMQR6pOZcSCsBwyQSo/DVA+57OhA7fuk
         LLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693225307; x=1693830107;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q6znZ4h/bFO0y4zxr99DQkfyX6CJsaAjv1JSqCiqfzY=;
        b=TqTCbHqtRz5vg3+eNuJ/7JkiuTGWKlMAOha1ISPOAxohTyu2+WvlQZj+v+GppYgWXD
         AJtAq1+Jr5PsMl5RJLGy6fGbQlfRrOveXnWoLdC/mPWla7L8I6ocFeWFg9MDhIpyC3Dr
         4hKrDnehZydZdS6ayVUWtgGSXsl11O11wYMKjcIGwqfWlh6fn4lLz3eEVIUJQWR0S8wJ
         om+KGr4Oj47AoclVZji9O0n60/6WnIndxsJDmzNwbJjLV1R/J1oku4XYO8WFbMJVscxF
         MzWGn3pK/d/4Fn/rv67Otc7TgXmTRUG6UKQPWuBvcNTxGC7dYB65kFwE7vOz2PficCCK
         25DQ==
X-Gm-Message-State: AOJu0YxKqwUdd3e299/oNGH5Adsvi5jjNAyMBb2zokTWziZXvymIVdUd
	T3jP9WEss8EkfrgOZczspzMg2aj1P8U=
X-Google-Smtp-Source: AGHT+IE88Atx2Kl8Xffh+ob+U1ncS/6fC4lpLtDEHx5q8BAYotEQ5Z4agnF24PO1fxpIf9JAc3NcrrV8vrw=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:d62e:36f4:33c6:e661])
 (user=gnoack job=sendgmr) by 2002:a17:907:6215:b0:9a1:b54e:4e5a with SMTP id
 ms21-20020a170907621500b009a1b54e4e5amr352372ejc.6.1693225307406; Mon, 28 Aug
 2023 05:21:47 -0700 (PDT)
Date: Mon, 28 Aug 2023 14:21:09 +0200
In-Reply-To: <20230828122109.3529221-1-gnoack@google.com>
Message-Id: <20230828122109.3529221-2-gnoack@google.com>
Mime-Version: 1.0
References: <20230828122109.3529221-1-gnoack@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Subject: [PATCH v2 1/1] tty: Restrict access to TIOCLINUX' copy-and-paste subcommands
From: "=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "=?UTF-8?q?Hanno=20B=C3=B6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, KP Singh <kpsingh@google.com>, 
	Nico Schottelius <nico-gpm2008@schottelius.org>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hanno B=C3=B6ck <hanno@hboeck.de>

TIOCLINUX can be used for privilege escalation on virtual terminals when
code is executed via tools like su/sudo and sandboxing tools.

By abusing the selection features, a lower-privileged application can
write content to the console, select and copy/paste that content and
thereby executing code on the privileged account. See also the poc
here:

  https://www.openwall.com/lists/oss-security/2023/03/14/3

Selection is usually used by tools like gpm that provide mouse features
on the virtual console. gpm already runs as root (due to earlier
changes that restrict access to a user on the current TTY), therefore
it will still work with this change.

With this change, the following TIOCLINUX subcommands require
CAP_SYS_ADMIN:

 * TIOCL_SETSEL - setting the selected region on the terminal
 * TIOCL_PASTESEL - pasting the contents of the selected region into
   the input buffer
 * TIOCL_SELLOADLUT - changing word-by-word selection behaviour

The security problem mitigated is similar to the security risks caused
by TIOCSTI, which, since kernel 6.2, can be disabled with
CONFIG_LEGACY_TIOCSTI=3Dn.

Signed-off-by: Hanno B=C3=B6ck <hanno@hboeck.de>
Tested-by: G=C3=BCnther Noack <gnoack@google.com>
---
 drivers/tty/vt/vt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 1e8e57b45688..1eb30ed1118d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3156,9 +3156,13 @@ int tioclinux(struct tty_struct *tty, unsigned long =
arg)
=20
 	switch (type) {
 	case TIOCL_SETSEL:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		return set_selection_user((struct tiocl_selection
 					 __user *)(p+1), tty);
 	case TIOCL_PASTESEL:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		return paste_selection(tty);
 	case TIOCL_UNBLANKSCREEN:
 		console_lock();
@@ -3166,6 +3170,8 @@ int tioclinux(struct tty_struct *tty, unsigned long a=
rg)
 		console_unlock();
 		break;
 	case TIOCL_SELLOADLUT:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		console_lock();
 		ret =3D sel_loadlut(p);
 		console_unlock();
--=20
2.42.0.rc2.253.gd59a3bf2b4-goog

