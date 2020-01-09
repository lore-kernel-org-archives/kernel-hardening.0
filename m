Return-Path: <SRS0=3MSu=26=lists.openwall.com=kernel-hardening-return-17557-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF875C282DD
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jan 2020 19:32:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F0BD82051A
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jan 2020 19:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RARJ8a4K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0BD82051A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17557-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7564 invoked by uid 550); 9 Jan 2020 19:32:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1939 invoked from network); 9 Jan 2020 16:08:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1578586106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rIO2h9KrEYPabWRX3TDhKhoqSrg8+Z2neV2hGtzX3p0=;
	b=RARJ8a4KEW5xHl9SZK2Fil1zMQgZcN3Ke/qDaVUka6nWDBgWiXCDtmCcEXydtQty2KyA/1
	CoePmhUmH3bK0iOmXL9fRcvxPdZZ0aIcuCSDWWQyo4rORgMABIuR+QNO9p4F4Lc47RRAr0
	7YveBhvAnHJG87+sWw+MU295nAT+Wzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XdbyLSo/LKwv0IS4UY8BmEznN2tnAhqPqp9PsERe1ZM=;
        b=NE7J3dq2TeL/U4+I1tGLg7yDd7w4Oh5ApN+QWzHb9E5i2rAuBIM4qNfINS0bF8ewFF
         HDDfVgZ7eyb+wdDWYk+6oDQu+fsem4xsN/eYDQmjeQdOAeU5IISZw3BMjw4R4aHhWpeT
         8eDid8/8IlkRbNBaxSLU7lvzdIZ8gVV6TVruZWk2YnEiPzd0h0CUUxlfNs+SJIJl/3NY
         hBWv5LCsAHjMfN6DsBVsAK/y7MujbuOvyE7wuDFgLudNIPEqWH8e8YP1ygPbj+Zz4639
         5R4W9yddHFY6wF9b4m+ZCfXZFI8OR5u8s0rJuIz//FDXmJq1y0ZyF1hunM7GCVdocwQU
         QDXg==
X-Gm-Message-State: APjAAAUaBN3Lr4ytBG3ecAZk6NcluITcoD7St0F+MJe5DHP0+NDeLnKX
	EDroTeqrQKDEpxGrI2BlfJy/Ho5ra52SGYSg0L3MDx8gd5/zRDsVubKiVeEBPKYgr4tZnrvb18E
	Iz23kSe9B2iuU6/Oyk41CGR64MMOqWZJrrw==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr5629110wml.173.1578586100899;
        Thu, 09 Jan 2020 08:08:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqybaGwF2SifAH/vF/5c/Zg4lZFldMQtCNPmw+l0nkZ5ezrMFKLX54upiO65e6Aqyi7sdLTdig==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr5629084wml.173.1578586100669;
        Thu, 09 Jan 2020 08:08:20 -0800 (PST)
From: Julien Thierry <jthierry@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: jpoimboe@redhat.com,
	peterz@infradead.org,
	raphael.gault@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Julien Thierry <jthierry@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Kees Cook <keescook@chromium.org>,
	Emese Revfy <re.emese@gmail.com>,
	linux-kbuild@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC v5 43/57] gcc-plugins: objtool: Add plugin to detect switch table on arm64
Date: Thu,  9 Jan 2020 16:02:46 +0000
Message-Id: <20200109160300.26150-44-jthierry@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200109160300.26150-1-jthierry@redhat.com>
References: <20200109160300.26150-1-jthierry@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 95rmweW2OMiDK0b4Dbx5hQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

From: Raphael Gault <raphael.gault@arm.com>

This plugins comes into play before the final 2 RTL passes of GCC and
detects switch-tables that are to be outputed in the ELF and writes
information in an ".discard.switch_table_info" section which will be
used by objtool.

Signed-off-by: Raphael Gault <raphael.gault@arm.com>
[J.T.: Change section name to store switch table information,
       Make plugin Kconfig be selected rather than opt-in by user,
       Add a relocation in the switch_table_info that points to
       the jump operation itself]
Signed-off-by: Julien Thierry <jthierry@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 arch/arm64/Kconfig                            |  1 +
 scripts/Makefile.gcc-plugins                  |  2 +
 scripts/gcc-plugins/Kconfig                   |  4 +
 .../arm64_switch_table_detection_plugin.c     | 94 +++++++++++++++++++
 4 files changed, 101 insertions(+)
 create mode 100644 scripts/gcc-plugins/arm64_switch_table_detection_plugin=
.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1b4476ddb83..a7b2116d5d13 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -90,6 +90,7 @@ config ARM64
 =09select DMA_DIRECT_REMAP
 =09select EDAC_SUPPORT
 =09select FRAME_POINTER
+=09select GCC_PLUGIN_SWITCH_TABLES if STACK_VALIDATION
 =09select GENERIC_ALLOCATOR
 =09select GENERIC_ARCH_TOPOLOGY
 =09select GENERIC_CLOCKEVENTS
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 5f7df50cfe7a..a56736df9dc2 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -44,6 +44,8 @@ ifdef CONFIG_GCC_PLUGIN_ARM_SSP_PER_TASK
 endif
 export DISABLE_ARM_SSP_PER_TASK_PLUGIN

+gcc-plugin-$(CONFIG_GCC_PLUGIN_SWITCH_TABLES)=09+=3D arm64_switch_table_de=
tection_plugin.so
+
 # All the plugin CFLAGS are collected here in case a build target needs to
 # filter them out of the KBUILD_CFLAGS.
 GCC_PLUGINS_CFLAGS :=3D $(strip $(addprefix -fplugin=3D$(objtree)/scripts/=
gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index e3569543bdac..f50047939660 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -112,4 +112,8 @@ config GCC_PLUGIN_ARM_SSP_PER_TASK
 =09bool
 =09depends on GCC_PLUGINS && ARM

+config GCC_PLUGIN_SWITCH_TABLES
+=09bool
+=09depends on GCC_PLUGINS && ARM64
+
 endif
diff --git a/scripts/gcc-plugins/arm64_switch_table_detection_plugin.c b/sc=
ripts/gcc-plugins/arm64_switch_table_detection_plugin.c
new file mode 100644
index 000000000000..9b8b2ec6a3c8
--- /dev/null
+++ b/scripts/gcc-plugins/arm64_switch_table_detection_plugin.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include "gcc-common.h"
+
+__visible int plugin_is_GPL_compatible;
+
+#define GEN_QUAD(rtx)=09assemble_integer_with_op(".quad ", rtx)
+
+/*
+ * Create an array of metadata for each jump table found in the rtl.
+ * The metadata contains:
+ * - A pointer to the table of offsets used for the actual branch
+ * - A pointer to first instruction of the group getting expanded into an
+ *   acutal jump
+ * - The number of entries in the table of offsets
+ * - Whether the offsets in the table are signed or not
+ */
+static unsigned int arm64_switchtbl_rtl_execute(void)
+{
+=09rtx_insn *insn;
+=09rtx_insn *labelp =3D NULL;
+=09rtx_jump_table_data *tablep =3D NULL;
+=09section *swt_sec;
+=09section *curr_sec =3D current_function_section();
+
+=09swt_sec =3D get_section(".discard.switch_table_info",
+=09=09=09      SECTION_EXCLUDE | SECTION_COMMON, NULL);
+
+=09for (insn =3D get_insns(); insn; insn =3D NEXT_INSN(insn)) {
+=09=09/*
+=09=09 * Find a tablejump_p INSN (using a dispatch table)
+=09=09 */
+=09=09if (!tablejump_p(insn, &labelp, &tablep))
+=09=09=09continue;
+
+=09=09if (labelp && tablep) {
+=09=09=09rtx_code_label *label_to_jump;
+
+=09=09=09/*
+=09=09=09 * GCC is a bit touchy about adding the label right
+=09=09=09 * before the jump rtx_insn as it modifies the
+=09=09=09 * basic_block created for the jump table.
+=09=09=09 * Make sure we create the label before the whole
+=09=09=09 * basic_block of the jump table.
+=09=09=09 */
+=09=09=09label_to_jump =3D gen_label_rtx();
+=09=09=09SET_LABEL_KIND(label_to_jump, LABEL_NORMAL);
+=09=09=09emit_label_before(label_to_jump, insn);
+=09=09=09/* Force label to be kept, apparently LABEL_PRESERVE_P is an rval=
ue :) */
+=09=09=09LABEL_PRESERVE_P(label_to_jump) =3D 1;
+
+=09=09=09switch_to_section(swt_sec);
+=09=09=09GEN_QUAD(gen_rtx_LABEL_REF(Pmode, labelp));
+=09=09=09GEN_QUAD(gen_rtx_LABEL_REF(Pmode, label_to_jump));
+=09=09=09GEN_QUAD(GEN_INT(GET_NUM_ELEM(tablep->get_labels())));
+=09=09=09GEN_QUAD(GEN_INT(ADDR_DIFF_VEC_FLAGS(tablep).offset_unsigned));
+=09=09=09switch_to_section(curr_sec);
+
+=09=09=09/*
+=09=09=09 * Scheduler isn't very happy about leaving labels in
+=09=09=09 * the middle of jump table basic blocks.
+=09=09=09 */
+=09=09=09delete_insn(label_to_jump);
+=09=09}
+=09}
+=09return 0;
+}
+
+#define PASS_NAME arm64_switchtbl_rtl
+
+#define NO_GATE
+#include "gcc-generate-rtl-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info,
+=09=09=09  struct plugin_gcc_version *version)
+{
+=09const char * const plugin_name =3D plugin_info->base_name;
+=09int tso =3D 0;
+=09int i;
+
+=09if (!plugin_default_version_check(version, &gcc_version)) {
+=09=09error(G_("incompatible gcc/plugin versions"));
+=09=09return 1;
+=09}
+
+=09PASS_INFO(arm64_switchtbl_rtl, "expand", 1,
+=09=09  PASS_POS_INSERT_AFTER);
+
+=09register_callback(plugin_info->base_name, PLUGIN_PASS_MANAGER_SETUP,
+=09=09=09  NULL, &arm64_switchtbl_rtl_pass_info);
+
+=09return 0;
+}
--
2.21.0

