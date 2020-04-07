Return-Path: <SRS0=8SO1=5X=lists.openwall.com=kernel-hardening-return-18455-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20C3C2BB1D
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 11:33:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3FCF22063A
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 11:33:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=qubes-os.org header.i=frederic.pierret@qubes-os.org header.b="RhskYl71"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FCF22063A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=qubes-os.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18455-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3602 invoked by uid 550); 7 Apr 2020 11:33:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3570 invoked from network); 7 Apr 2020 11:33:38 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1586259204; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=SQJ4J3gdSHaAMJrAW2vforzWyw2HsCPIDymu1UirJX5baA3vwJe7dTqCwjAEVuVM7D9ln4rmRzEOO9id2GN3SraE3cEoETJudsPsprvBgR6F2rxW5jsfsdrmysdLyf9nlLJgNdSmocWdktBsWrzZ3h+tLlE1+h/jjqVYWUCLhow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1586259204; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
	bh=C/Yq67cW8uTVVpw1SfMGvhEYjHhJY1OJC8jyQ+cJV/s=; 
	b=BXuIgPue5YQpbdEGogRNrq256YcfNTscgiQEZ4zkrRzccsTQkXQElgKVYJGydLj3kOQe3t98WLjCjTbGkBSyz2MAtQVyOVpnMafy91RzX92JEVVpH1wpCqg/selqsWOSHwoGYtPSQSuY6eVBJQUZwHU/KUBJFWXkGSEBra3B8P4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=qubes-os.org;
	spf=pass  smtp.mailfrom=frederic.pierret@qubes-os.org;
	dmarc=pass header.from=<frederic.pierret@qubes-os.org> header.from=<frederic.pierret@qubes-os.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586259204;
	s=s; d=qubes-os.org; i=frederic.pierret@qubes-os.org;
	h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C/Yq67cW8uTVVpw1SfMGvhEYjHhJY1OJC8jyQ+cJV/s=;
	b=RhskYl71ugxP1z+Y7zz+0MDN+ttSoPYMyRG9M+2ugxCe3Z/xLIFpfFb9BWHZGyb7
	XXLbAXx41Y6mBHAcKtjCPEA4benFGfW7o51MWrzc3sWbd1Gcsr7/mDjRrwAn3xlE1Ik
	S3h6cHXti3yMZg+DThXzREE14n/R/1NNKhKTWork=
From: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Pierret=20=28fepitre=29?= <frederic.pierret@qubes-os.org>
To: keescook@chromium.org,
	re.emese@gmail.com,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Pierret=20=28fepitre=29?= <frederic.pierret@qubes-os.org>
Message-ID: <20200407113259.270172-1-frederic.pierret@qubes-os.org>
Subject: [PATCH] gcc-common.h: 'params.h' has been dropped in GCC10
Date: Tue,  7 Apr 2020 13:32:59 +0200
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External

Moreover, GCC10 complains about gimple definition. For example,
doing a 'scripts/gcc-plugin.sh g++ g++ gcc' returns:

In file included from <stdin>:1:
./gcc-plugins/gcc-common.h:852:13: error: redefinition of =E2=80=98static b=
ool is_a_helper<T>::test(U*) [with U =3D const gimple; T =3D const ggoto*]=
=E2=80=99
  852 | inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./gcc-plugins/gcc-common.h:125,
                 from <stdin>:1:
/usr/lib/gcc/x86_64-redhat-linux/10/plugin/include/gimple.h:1037:1: note: =
=E2=80=98static bool is_a_helper<T>::test(U*) [with U =3D const gimple; T =
=3D const ggoto*]=E2=80=99 previously declared here
 1037 | is_a_helper <const ggoto *>::test (const gimple *gs)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from <stdin>:1:
./gcc-plugins/gcc-common.h:859:13: error: redefinition of =E2=80=98static b=
ool is_a_helper<T>::test(U*) [with U =3D const gimple; T =3D const greturn*=
]=E2=80=99
  859 | inline bool is_a_helper<const greturn *>::test(const_gimple gs)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./gcc-plugins/gcc-common.h:125,
                 from <stdin>:1:
/usr/lib/gcc/x86_64-redhat-linux/10/plugin/include/gimple.h:1489:1: note: =
=E2=80=98static bool is_a_helper<T>::test(U*) [with U =3D const gimple; T =
=3D const greturn*]=E2=80=99 previously declared here
 1489 | is_a_helper <const greturn *>::test (const gimple *gs)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A hacky way for solving this is to ignore them for GCC10.

Signed-off-by: Fr=C3=A9d=C3=A9ric Pierret (fepitre) <frederic.pierret@qubes=
-os.org>
---
 scripts/gcc-plugins/gcc-common.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-com=
mon.h
index 17f06079a712..9ad76b7f3f10 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -35,7 +35,9 @@
 #include "ggc.h"
 #include "timevar.h"
=20
+#if BUILDING_GCC_VERSION < 10000
 #include "params.h"
+#endif
=20
 #if BUILDING_GCC_VERSION <=3D 4009
 #include "pointer-set.h"
@@ -847,6 +849,7 @@ static inline gimple gimple_build_assign_with_ops(enum =
tree_code subcode, tree l
 =09return gimple_build_assign(lhs, subcode, op1, op2 PASS_MEM_STAT);
 }
=20
+#if BUILDING_GCC_VERSION < 10000
 template <>
 template <>
 inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
@@ -860,6 +863,7 @@ inline bool is_a_helper<const greturn *>::test(const_gi=
mple gs)
 {
 =09return gs->code =3D=3D GIMPLE_RETURN;
 }
+#endif
=20
 static inline gasm *as_a_gasm(gimple stmt)
 {
--=20
2.25.2


