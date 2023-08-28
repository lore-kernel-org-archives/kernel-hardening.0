Return-Path: <kernel-hardening-return-21682-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 42390C83F12
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 12:21:58 +0000 (UTC)
Received: (qmail 3183 invoked by uid 550); 28 Aug 2023 12:21:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3148 invoked from network); 28 Aug 2023 12:21:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693225295; x=1693830095;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0fazXoo+ou5IcbHLqcGgvL3F6Iss6gQV1TDIxc8Xgko=;
        b=DSjCX5zVXq5aronukNbxD5A+wTeyyDEhRsedv45rBILJkVCXeYCA7vvi/MsygbsJcC
         yjYd0kh14W6mzHeHJnhyLyKA8tIuSGhQc6bUV3XVrONKdKtMEAszNkvh0argKhLNl1Zp
         BXmGMLv6t3Zjojb0eFnEfdShmIPrifZsUUdQWYAD10A4zKXnm3JWV0s1FIZUCWjdpDmd
         DsERuJrc/UnJC+I8NwWAwpL82fvFOBBvu7ga7LjIDrrV7k/9bm80bmqe1ExtIs+CeKjI
         gPfaZ+ueCqtuVoqQtzbDrdvAs6tFEhUmyY29aRluO9iG3OCGs3txSwfqGClRIRek2KYh
         lfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693225295; x=1693830095;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fazXoo+ou5IcbHLqcGgvL3F6Iss6gQV1TDIxc8Xgko=;
        b=Wqm8oEuUrevLFL5ceKdy1TJwJ2AhdRUPxMgZa/GSNjjzAzFkXNf/u/0X+GiLb7X0ZN
         JSkl0KBNJTY4+POppbAY82i/x1IYtj0sW2d9uHLAKOZ5HRuEaMOx8hP7B3Qwt/sqWh1t
         83d0TVcQmNI8qaFB6vwWAOV4fLL0DOPqrpF3fZgkSUFQdYpAEH7wyzk+jwFsB4FnP2iN
         aaagn9n4tHtAesOGbnDJpTycc3uNu+e5kjzfJEvLNBauDVr3fwU3FOcA92JzJmreQIBx
         zsgqSGfLCZHnofO1Fla5OBhDf9gka8bUqVv5IDx2aT/JPz7sdyFpQXhBrG5j2THROcfo
         VmRw==
X-Gm-Message-State: AOJu0YxYV9qdApFzO64sY96Kn4FTSCzf7u9zIOQ9psiNCnPrUSgJegPa
	l8C5PdCo2GTKi9Nqn6kfneNCl7epNGw=
X-Google-Smtp-Source: AGHT+IHkPB/b0nsyOgPx0t2SavNcBfJG2ypRE23GdFMKVZyoPH3h9lbtsnHQphsCbtz0nJRuwESrD7X69PU=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:d62e:36f4:33c6:e661])
 (user=gnoack job=sendgmr) by 2002:a05:6902:106:b0:d77:984e:c770 with SMTP id
 o6-20020a056902010600b00d77984ec770mr721344ybh.5.1693225294898; Mon, 28 Aug
 2023 05:21:34 -0700 (PDT)
Date: Mon, 28 Aug 2023 14:21:08 +0200
Message-Id: <20230828122109.3529221-1-gnoack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Subject: [PATCH v2 0/1] Restrict access to TIOCLINUX
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

Hello!

This is a re-send of a patch by Hanno B=C3=B6ck from 2023-04-02 [1], to res=
trict the
use of the copy-and-paste functionality in the TIOCLINUX IOCTL.

These copy-and-paste operations can be misused in the same way as the TIOCS=
TI
IOCTL, which can be disabled with a CONFIG option, since commit 83efeeeb3d0=
4
("tty: Allow TIOCSTI to be disabled") and commit 690c8b804ad2 ("TIOCSTI: al=
ways
enable for CAP_SYS_ADMIN").  With this option set to N, the use of TIOCSTI
requires CAP_SYS_ADMIN.

We believe that it should be OK to not make this configurable: For TIOCLINU=
X's
copy-and-paste subcommands, the only known usage so far is GPM.  I have
personally verified that this continues to work, as GPM runs as root.

The number of affected programs should be much lower than it was the case f=
or
TIOCSTI (as TIOCLINUX only applies to virtual terminals), and even in the
TIOCLINUX case, only a handful of legitimate use cases were mentioned.  (BR=
LTTY,
tcsh, Emacs, special versions of "mail").  I have high confidence that GPM =
is
the only existing usage of that copy-and-paste feature.

(If configurability is really required, the way to be absolutely sure would=
 be
to introduce a CONFIG option for it as well -- but it would be a pretty obs=
cure
option to have, but we can do that if needed.)

Changes in v2:
 - Rebased to Linux v6.5
 - Reworded commit message a bit
 - Added Tested-By

[1] https://lore.kernel.org/all/20230402160815.74760f87.hanno@hboeck.de/

Hanno B=C3=B6ck (1):
  tty: Restrict access to TIOCLINUX' copy-and-paste subcommands

 drivers/tty/vt/vt.c | 6 ++++++
 1 file changed, 6 insertions(+)


base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
--=20
2.42.0.rc2.253.gd59a3bf2b4-goog

