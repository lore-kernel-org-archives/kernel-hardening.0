Return-Path: <kernel-hardening-return-21686-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B0502C83F11
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 16:41:44 +0000 (UTC)
Received: (qmail 6082 invoked by uid 550); 28 Aug 2023 16:41:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6047 invoked from network); 28 Aug 2023 16:41:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693240881; x=1693845681;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XMrfQtetFvjJkWkXWlT+oLZSEP+aJV6/gt1SPjsPEuY=;
        b=Gi9doidbpT8T97LpgJzeZvDfd5NYbAB3LOEiPnEZ9IBMNkC4ZmEx3oReZKk3pMNSmI
         O9o5fPIPV4iysCMeH1Fd4/PgMG2PV9zara8xQim0G1nJWiFPG2/9run6ZK+JImL1e6RB
         kydnAIzq6Q7aytJMOF8pkZb8eDCdFuiFIZlm4eRf8+nxPwjqwdyodSz6zYS7Q0RzSHne
         zvpDo8+IO0lt84qtTP4newqQ/jSmUgFFn8zXZEyPA4o1sroBsn9RhaB6c1kSc1dW8Hxx
         QgySCY3DwpmFs818VBFf44mM4Q+35ah5VwBM243wQPVXyi2dpVup+AyQZ8ISpjHYvgeH
         Xxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693240881; x=1693845681;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMrfQtetFvjJkWkXWlT+oLZSEP+aJV6/gt1SPjsPEuY=;
        b=KGKOzczeids16mB06oclw4MMZSWWIa1CPEDFeWckTo8LrxQmVVjWrZrfs4qjFEsG6q
         7eC0Rvy/2PYvknUNYnLBd5aOvT4bIt8NCAVQhQxIRF2fjD6PDNuE1lMgT8np4KAD2N88
         FsrzQoKdWqi4AMWBeMUZeWN5Q2F+BZk08Az6XK4JYbWDxngIE8WI1mtUKWUcX89ekoS/
         eGqgl2aX4Ypp+lmuioPbCYKTg+1isSzdy6HtEFF1ECAwxcuPXq8G5Aw9IHkR3xzt9w69
         sHvwFDHdlupwOaYmKgbCGEDfg6Csuql49WlUYvOWRAUOuvL72je1MztyDci7gXdiyiyt
         ZWCA==
X-Gm-Message-State: AOJu0YyGPN0/IuxomjEYMQVWSHazJhk4Jwr3K0LpqFvNW2XKqPY2p87Z
	ItqQ1VoxFU4gmDtr5JbG8fkbZQZy2/k=
X-Google-Smtp-Source: AGHT+IEvB188fo2loS1+NcaNJpP6FWYlIW5rMK7g+apmJhbYIdoj84EHxPhfNZS6l33Tucb0dVn/J5Ofvmo=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:d62e:36f4:33c6:e661])
 (user=gnoack job=sendgmr) by 2002:a50:aac7:0:b0:522:aad5:4f89 with SMTP id
 r7-20020a50aac7000000b00522aad54f89mr3502edc.1.1693240881242; Mon, 28 Aug
 2023 09:41:21 -0700 (PDT)
Date: Mon, 28 Aug 2023 18:41:16 +0200
Message-Id: <20230828164117.3608812-1-gnoack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Subject: [PATCH v3 0/1] Restrict access to TIOCLINUX
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

Changes in v3:
 - Added missing Signed-off-by: line

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

