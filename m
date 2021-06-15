Return-Path: <SRS0=ktvs=LJ=lists.openwall.com=kernel-hardening-return-21304-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C00CC48BDF
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 16:42:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E98C6188B
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 16:42:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E98C6188B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21304-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18279 invoked by uid 550); 15 Jun 2021 16:42:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18244 invoked from network); 15 Jun 2021 16:42:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5HqZgwKlnzHk7eYEZtH1CaDCUYRbqEaAMkPzJHvXqS0=;
        b=mybjY4le4ctEWGm4xYu2iOggsKW4q3/OyS+MxcoV+4sj4lWFwwnQNlmhPG+4ab8x1U
         eGsvSWvravHxwru85zseEObBLKnmFFAKleEjMXqFeo/AAKK7F6vHUQiMTj+LkjBYl9CB
         ElZy+6UTOxwulqLE/1DJtATQRhuNKzyaBTKdMu9bO2tSvsq/EwMG3Qcbm1oHHuWPvkoc
         JEwU2r3TJyNZ81FlgaipOWrPVgZNpCEz8C5Xr5Id0F15hRR3wGRIexVErFKRcAmYHupS
         u/NOU4f1YPVY6dlllL4AvnoSJ3H1Xo7QDnLZpOjoPAAN2Fe5nt0pyXyroPiQVTWwjCoM
         lLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5HqZgwKlnzHk7eYEZtH1CaDCUYRbqEaAMkPzJHvXqS0=;
        b=G6//66OINHLSMkMojH6vC5DfVxrNZqYaX+F+rHnYFZvcgRppyhvwkQz6NXREv1GjFc
         2TKsFeYaPPqSXC6qTKg0qTzAv/+F7gzR34Xxyysec4WccOsnJNxlT2rj3punrlEgSBBs
         1Pvy8pCOEVSULYHyzyhGaEZvGbaZo4DQJesf6UZBPaMLWAaJcBbnOGreFKxzL3qimewW
         CkqDwXRlEhKmWZjFZYIPlCcfDmy2/1hMhqT7LbnFmrf7M+OWZKD8jlPTQB3DaOIs2eiK
         RuOQnRsXshyWogII1dlhEgLEUTsSioNYjNknvWudVL7CiUB2QQfec+yM/+f0e6htWRtZ
         YRww==
X-Gm-Message-State: AOAM530ZW3sk+iPaegSFhQkZqNJxFbe8y4eUM+rXlNPAr8gvJrFaglYD
	AtbwmPOk3L3LLaYM+ys45iA=
X-Google-Smtp-Source: ABdhPJwp84+Gas8I1iFxMF+l7Gvuia2vMA5qr7ms18jAFHC17zcr6iYbk+siFXsqqCOGOhy2a2vdPw==
X-Received: by 2002:a05:6000:110e:: with SMTP id z14mr26964792wrw.235.1623775347448;
        Tue, 15 Jun 2021 09:42:27 -0700 (PDT)
From: Kurt Manucredo <fuzzybritches0@gmail.com>
To: ebiggers@kernel.org,
	syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Cc: Kurt Manucredo <fuzzybritches0@gmail.com>,
	keescook@chromium.org,
	yhs@fb.com,
	dvyukov@google.com,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	kafai@fb.com,
	kpsingh@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	songliubraving@fb.com,
	syzkaller-bugs@googlegroups.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	kasan-dev@googlegroups.com
Subject: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Date: Tue, 15 Jun 2021 16:42:10 +0000
Message-Id: <85536-177443-curtm@phaethon>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YMJvbGEz0xu9JU9D@gmail.com>
References: <87609-531187-curtm@phaethon> <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com> <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com> <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com> <202106091119.84A88B6FE7@keescook> <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com> <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com> <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook> <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
kernel/bpf/core.c:1414:2.

The shift-out-of-bounds happens when we have BPF_X. This means we have
to go the same way we go when we want to avoid a divide-by-zero. We do
it in do_misc_fixups().

When we have BPF_K we find divide-by-zero and shift-out-of-bounds guards
next each other in check_alu_op(). It seems only logical to me that the
same should be true for BPF_X in do_misc_fixups() since it is there where
I found the divide-by-zero guard. Or is there a reason I'm not aware of,
that dictates that the checks should be in adjust_scalar_min_max_vals(),
as they are now?

This patch was tested by syzbot.

Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
---

https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231

Changelog:
----------
v5 - Fix shift-out-of-bounds in do_misc_fixups().
v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
     Fix commit message.
v3 - Make it clearer what the fix is for.
v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
     check in check_alu_op() in verifier.c.
v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
     check in ___bpf_prog_run().

thanks

kind regards

Kurt

 kernel/bpf/verifier.c | 53 +++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 94ba5163d4c5..83c7c1ccaf26 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7496,7 +7496,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	u64 umin_val, umax_val;
 	s32 s32_min_val, s32_max_val;
 	u32 u32_min_val, u32_max_val;
-	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
 	bool alu32 = (BPF_CLASS(insn->code) != BPF_ALU64);
 	int ret;
 
@@ -7592,39 +7591,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		scalar_min_max_xor(dst_reg, &src_reg);
 		break;
 	case BPF_LSH:
-		if (umax_val >= insn_bitness) {
-			/* Shifts greater than 31 or 63 are undefined.
-			 * This includes shifts by a negative number.
-			 */
-			mark_reg_unknown(env, regs, insn->dst_reg);
-			break;
-		}
 		if (alu32)
 			scalar32_min_max_lsh(dst_reg, &src_reg);
 		else
 			scalar_min_max_lsh(dst_reg, &src_reg);
 		break;
 	case BPF_RSH:
-		if (umax_val >= insn_bitness) {
-			/* Shifts greater than 31 or 63 are undefined.
-			 * This includes shifts by a negative number.
-			 */
-			mark_reg_unknown(env, regs, insn->dst_reg);
-			break;
-		}
 		if (alu32)
 			scalar32_min_max_rsh(dst_reg, &src_reg);
 		else
 			scalar_min_max_rsh(dst_reg, &src_reg);
 		break;
 	case BPF_ARSH:
-		if (umax_val >= insn_bitness) {
-			/* Shifts greater than 31 or 63 are undefined.
-			 * This includes shifts by a negative number.
-			 */
-			mark_reg_unknown(env, regs, insn->dst_reg);
-			break;
-		}
 		if (alu32)
 			scalar32_min_max_arsh(dst_reg, &src_reg);
 		else
@@ -12353,6 +12331,37 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		/* Make shift-out-of-bounds exceptions impossible. */
+		if (insn->code == (BPF_ALU64 | BPF_LSH | BPF_X) ||
+		    insn->code == (BPF_ALU64 | BPF_RSH | BPF_X) ||
+		    insn->code == (BPF_ALU64 | BPF_ARSH | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_LSH | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_RSH | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_ARSH | BPF_X)) {
+			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
+			u8 insn_bitness = is64 ? 64 : 32;
+			struct bpf_insn chk_and_shift[] = {
+				/* [R,W]x shift >= 32||64 -> 0 */
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JLT | BPF_K, insn->src_reg,
+					     insn_bitness, 2, 0),
+				BPF_ALU32_REG(BPF_XOR, insn->dst_reg, insn->dst_reg),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				*insn,
+			};
+
+			cnt = ARRAY_SIZE(chk_and_shift);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, chk_and_shift, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 		/* Implement LD_ABS and LD_IND with a rewrite, if supported by the program type. */
 		if (BPF_CLASS(insn->code) == BPF_LD &&
 		    (BPF_MODE(insn->code) == BPF_ABS ||
-- 
2.30.2

