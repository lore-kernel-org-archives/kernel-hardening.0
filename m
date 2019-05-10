From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
Date: Fri, 10 May 2019 21:00:25 +1200
Message-Id: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: keescook@chromium.org, re.emese@gmail.com
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Chris Packham <chris.packham@alliedtelesis.co.nz>
List-ID: <kernel-hardening.lists.openwall.com>

Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
that handles the difference between GCC versions implementing
the latter.

This fixes the following error on my system with g++ 5.4.0 as the host
compiler

   HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen_r=
tx_SET" requires 3 arguments, but only 2 given
          mask)),
               ^
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function =E2=80=98unsi=
gned int arm_pertask_ssp_rtl_execute()=E2=80=99:
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: =E2=80=98gen=
_rtx_SET=E2=80=99 was not declared in this scope
    emit_insn_before(gen_rtx_SET

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-=
plugins/arm_ssp_per_task_plugin.c
index 89c47f57d1ce..8c1af9bdcb1b 100644
--- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
+++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
@@ -36,7 +36,7 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
 		mask =3D GEN_INT(sext_hwi(sp_mask, GET_MODE_PRECISION(Pmode)));
 		masked_sp =3D gen_reg_rtx(Pmode);
=20
-		emit_insn_before(gen_rtx_SET(masked_sp,
+		emit_insn_before(gen_rtx_set(masked_sp,
 					     gen_rtx_AND(Pmode,
 							 stack_pointer_rtx,
 							 mask)),
--=20
2.21.0
