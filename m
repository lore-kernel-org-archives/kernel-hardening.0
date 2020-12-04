Return-Path: <SRS0=nBEK=FI=lists.openwall.com=kernel-hardening-return-20532-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245B0C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Dec 2020 15:38:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 72A4922BF5
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Dec 2020 15:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72A4922BF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20532-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27920 invoked by uid 550); 4 Dec 2020 15:38:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27683 invoked from network); 4 Dec 2020 15:38:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVdGaK2bL2n+KcPpTJ+Tm19dWBScDKIPPOpZKFTCkrU=;
        b=rIZqXxFyy3ULH5D5cJjUEVj1eSSsp2qC+izzFmQSujqg4JwTpfEDRWeGeroLyfl+Y0
         vrjdqzSzS9L4BLFtkPM3rPg+WjG18jeMZVyvq+ok6UGyaPkQlLxyWS5pX5rf4JJTUawo
         kohZNz4VEaCJHtOs1SCvR2QfzU7X1NgFufQG3NIiER/i7T9K9HWRbZ9+rqBCHd+aCxDx
         eMVbWjuyyLm5WZquHsXjYjDfthE49+rGAiQL5/BFChJ5aoktMds/5/iGdZ4PHs0ZPeVl
         8r45m9zG10Z3oeLgUvFCb9WxxXOvMx2pvjeomItjPQEy0hIzxU8pMt5KjQPHEgqqJXGW
         8w9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVdGaK2bL2n+KcPpTJ+Tm19dWBScDKIPPOpZKFTCkrU=;
        b=N7gUo7PqA5EeSWehmKxspweQm4eAAPMOGV70v/O5W5SE6Kyj6Am9wQMaHX0Dv1iC+a
         Zc9coUuWoqo2xry1FPHu10MlGiw1XhQY11/MohcPhrLQlT1BEGPMAWB/hv22JiDFGG4c
         tihF27eZXdMTnIrXBPLullO9rkh3c9jLqMvvjHdJcIihwj7MROD/XX5BI0fgE4GcpxhV
         OlwJzXumlMbvQnCq/la0QN5ScQ/vg7yitn9+oAeAaTRPUMwUl7Bw8ol3kzrf7rIsrj46
         cvjL3lNvIwIfF61BB96nVnRDq7E6pAeCA6XxdjbS/L+b5SVkpwoWy3+kOaERQTFrKpNe
         PPLQ==
X-Gm-Message-State: AOAM5308UFT84epDmNNrdVikxohkCgBUmjwEpU0K9LRQAQXzgu19zIWN
	7DWtaafFIIGNIKDAQQZG5Yg=
X-Google-Smtp-Source: ABdhPJze2seZCwfnKLJMipk7KGfmKQhJeI1mLzvGXZ1ngBGUSIe8oNovwcomGiMqYH1mr/JbJcPLFw==
X-Received: by 2002:a7b:c11a:: with SMTP id w26mr4915148wmi.131.1607096284621;
        Fri, 04 Dec 2020 07:38:04 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 1/2] Manual replacement of the deprecated strlcpy() with return values
Date: Fri,  4 Dec 2020 16:37:53 +0100
Message-Id: <20201204153754.7941-2-romain.perier@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201204153754.7941-1-romain.perier@gmail.com>
References: <20201204153754.7941-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/m68k/emu/natfeat.c                 |  6 +--
 crypto/lrw.c                            |  6 +--
 crypto/xts.c                            |  6 +--
 drivers/dma-buf/dma-buf.c               |  4 +-
 drivers/hwmon/pmbus/max20730.c          | 66 +++++++++++++------------
 drivers/s390/char/diag_ftp.c            |  4 +-
 drivers/s390/char/sclp_ftp.c            |  6 +--
 drivers/s390/scsi/zfcp_fc.c             |  8 +--
 drivers/target/target_core_configfs.c   | 33 ++++---------
 drivers/tty/vt/keyboard.c               |  7 ++-
 drivers/usb/gadget/function/f_midi.c    |  4 +-
 drivers/usb/gadget/function/f_printer.c |  8 +--
 drivers/usb/usbip/stub_main.c           |  6 +--
 drivers/watchdog/diag288_wdt.c          | 12 +++--
 fs/kernfs/dir.c                         | 27 +++++-----
 kernel/cgroup/cgroup.c                  |  2 +-
 kernel/module.c                         |  4 +-
 kernel/trace/trace_uprobe.c             | 11 ++---
 lib/kobject_uevent.c                    |  6 +--
 net/core/devlink.c                      |  6 +--
 net/sunrpc/clnt.c                       |  6 ++-
 security/integrity/ima/ima_policy.c     |  8 ++-
 sound/usb/card.c                        |  4 +-
 23 files changed, 131 insertions(+), 119 deletions(-)

diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 71b78ecee75c..fbb3454d3c6a 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -41,10 +41,10 @@ long nf_get_id(const char *feature_name)
 {
 	/* feature_name may be in vmalloc()ed memory, so make a copy */
 	char name_copy[32];
-	size_t n;
+	ssize_t n;
 
-	n = strlcpy(name_copy, feature_name, sizeof(name_copy));
-	if (n >= sizeof(name_copy))
+	n = strscpy(name_copy, feature_name, sizeof(name_copy));
+	if (n == -E2BIG)
 		return 0;
 
 	return nf_get_id_phys(virt_to_phys(name_copy));
diff --git a/crypto/lrw.c b/crypto/lrw.c
index bcf09fbc750a..4d35f4439012 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		ssize_t len;
 
-		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-		if (len < 2 || len >= sizeof(ecb_name))
+		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		if (len == -E2BIG || len < 2)
 			goto err_free_inst;
 
 		if (ecb_name[len - 1] != ')')
diff --git a/crypto/xts.c b/crypto/xts.c
index ad45b009774b..9d4f1bf2e79c 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -395,10 +395,10 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
-		unsigned len;
+		ssize_t len;
 
-		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
-		if (len < 2 || len >= sizeof(ctx->name))
+		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		if (len == -E2BIG || len < 2)
 			goto err_free_inst;
 
 		if (ctx->name[len - 1] != ')')
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 844967f98866..2d364e0f2d2f 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -42,12 +42,12 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
 	struct dma_buf *dmabuf;
 	char name[DMA_BUF_NAME_LEN];
-	size_t ret = 0;
+	ssize_t ret = 0;
 
 	dmabuf = dentry->d_fsdata;
 	spin_lock(&dmabuf->name_lock);
 	if (dmabuf->name)
-		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
+		ret = strscpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
 	spin_unlock(&dmabuf->name_lock);
 
 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
diff --git a/drivers/hwmon/pmbus/max20730.c b/drivers/hwmon/pmbus/max20730.c
index be83b98411c7..53fa84f938fe 100644
--- a/drivers/hwmon/pmbus/max20730.c
+++ b/drivers/hwmon/pmbus/max20730.c
@@ -107,7 +107,8 @@ struct max20730_debugfs_data {
 static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	int ret, len;
+	int ret;
+	ssize_t len;
 	int *idxp = file->private_data;
 	int idx = *idxp;
 	struct max20730_debugfs_data *psu = to_psu(idxp, idx);
@@ -148,13 +149,13 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 			>> MAX20730_MFR_DEVSET1_TSTAT_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "2000\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "2000\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "125\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "125\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "62.5\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "62.5\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "32\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "32\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_INTERNAL_GAIN:
 		val = (data->mfr_devset1 & MAX20730_MFR_DEVSET1_RGAIN_MASK)
@@ -163,35 +164,35 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 		if (data->id == max20734) {
 			/* AN6209 */
 			if (val == 0)
-				len = strlcpy(tbuf, "0.8\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.8\n", DEBUG_FS_DATA_MAX);
 			else if (val == 1)
-				len = strlcpy(tbuf, "3.2\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "3.2\n", DEBUG_FS_DATA_MAX);
 			else if (val == 2)
-				len = strlcpy(tbuf, "1.6\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "1.6\n", DEBUG_FS_DATA_MAX);
 			else
-				len = strlcpy(tbuf, "6.4\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "6.4\n", DEBUG_FS_DATA_MAX);
 		} else if (data->id == max20730 || data->id == max20710) {
 			/* AN6042 or AN6140 */
 			if (val == 0)
-				len = strlcpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
 			else if (val == 1)
-				len = strlcpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
 			else if (val == 2)
-				len = strlcpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
 			else
-				len = strlcpy(tbuf, "7.2\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "7.2\n", DEBUG_FS_DATA_MAX);
 		} else if (data->id == max20743) {
 			/* AN6042 */
 			if (val == 0)
-				len = strlcpy(tbuf, "0.45\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.45\n", DEBUG_FS_DATA_MAX);
 			else if (val == 1)
-				len = strlcpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "1.8\n", DEBUG_FS_DATA_MAX);
 			else if (val == 2)
-				len = strlcpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "0.9\n", DEBUG_FS_DATA_MAX);
 			else
-				len = strlcpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
+				len = strscpy(tbuf, "3.6\n", DEBUG_FS_DATA_MAX);
 		} else {
-			len = strlcpy(tbuf, "Not supported\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "Not supported\n", DEBUG_FS_DATA_MAX);
 		}
 		break;
 	case MAX20730_DEBUGFS_BOOT_VOLTAGE:
@@ -199,26 +200,26 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 			>> MAX20730_MFR_DEVSET1_VBOOT_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "0.6484\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "0.6484\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "0.8984\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "0.8984\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "1.0\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "1.0\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_OUT_V_RAMP_RATE:
 		val = (data->mfr_devset2 & MAX20730_MFR_DEVSET2_VRATE)
 			>> MAX20730_MFR_DEVSET2_VRATE_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "4\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "4\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "2\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "2\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "1\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "1\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_OC_PROTECT_MODE:
 		ret = (data->mfr_devset2 & MAX20730_MFR_DEVSET2_OCPM_MASK)
@@ -230,13 +231,13 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 			>> MAX20730_MFR_DEVSET2_SS_BIT_POS;
 
 		if (val == 0)
-			len = strlcpy(tbuf, "0.75\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "0.75\n", DEBUG_FS_DATA_MAX);
 		else if (val == 1)
-			len = strlcpy(tbuf, "1.5\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "1.5\n", DEBUG_FS_DATA_MAX);
 		else if (val == 2)
-			len = strlcpy(tbuf, "3\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "3\n", DEBUG_FS_DATA_MAX);
 		else
-			len = strlcpy(tbuf, "6\n", DEBUG_FS_DATA_MAX);
+			len = strscpy(tbuf, "6\n", DEBUG_FS_DATA_MAX);
 		break;
 	case MAX20730_DEBUGFS_IMAX:
 		ret = (data->mfr_devset2 & MAX20730_MFR_DEVSET2_IMAX_MASK)
@@ -287,9 +288,12 @@ static ssize_t max20730_debugfs_read(struct file *file, char __user *buf,
 				"%d.%d\n", ret / 10000, ret % 10000);
 		break;
 	default:
-		len = strlcpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
+		len = strscpy(tbuf, "Invalid\n", DEBUG_FS_DATA_MAX);
 	}
 
+	if (len == -E2BIG)
+		return -E2BIG;
+
 	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
diff --git a/drivers/s390/char/diag_ftp.c b/drivers/s390/char/diag_ftp.c
index 6bf1058de873..c198dfcc85be 100644
--- a/drivers/s390/char/diag_ftp.c
+++ b/drivers/s390/char/diag_ftp.c
@@ -158,8 +158,8 @@ ssize_t diag_ftp_cmd(const struct hmcdrv_ftp_cmdspec *ftp, size_t *fsize)
 		goto out;
 	}
 
-	len = strlcpy(ldfpl->fident, ftp->fname, sizeof(ldfpl->fident));
-	if (len >= HMCDRV_FTP_FIDENT_MAX) {
+	len = strscpy(ldfpl->fident, ftp->fname, sizeof(ldfpl->fident));
+	if (len == -E2BIG) {
 		len = -EINVAL;
 		goto out_free;
 	}
diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
index dfdd6c8fd17e..525156926592 100644
--- a/drivers/s390/char/sclp_ftp.c
+++ b/drivers/s390/char/sclp_ftp.c
@@ -87,7 +87,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	struct completion completion;
 	struct sclp_diag_sccb *sccb;
 	struct sclp_req *req;
-	size_t len;
+	ssize_t len;
 	int rc;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
@@ -114,9 +114,9 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	sccb->evbuf.mdd.ftp.length = ftp->len;
 	sccb->evbuf.mdd.ftp.bufaddr = virt_to_phys(ftp->buf);
 
-	len = strlcpy(sccb->evbuf.mdd.ftp.fident, ftp->fname,
+	len = strscpy(sccb->evbuf.mdd.ftp.fident, ftp->fname,
 		      HMCDRV_FTP_FIDENT_MAX);
-	if (len >= HMCDRV_FTP_FIDENT_MAX) {
+	if (len == -E2BIG) {
 		rc = -EINVAL;
 		goto out_free;
 	}
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index d24cafe02708..8a65241011b9 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -877,14 +877,16 @@ static void zfcp_fc_rspn(struct zfcp_adapter *adapter,
 	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
 	struct zfcp_fc_rspn_req *rspn_req = &fc_req->u.rspn.req;
 	struct fc_ct_hdr *rspn_rsp = &fc_req->u.rspn.rsp;
-	int ret, len;
+	int ret;
+	ssize_t len;
 
 	zfcp_fc_ct_ns_init(&rspn_req->ct_hdr, FC_NS_RSPN_ID,
 			   FC_SYMBOLIC_NAME_SIZE);
 	hton24(rspn_req->rspn.fr_fid.fp_fid, fc_host_port_id(shost));
-	len = strlcpy(rspn_req->rspn.fr_name, fc_host_symbolic_name(shost),
+	len = strscpy(rspn_req->rspn.fr_name, fc_host_symbolic_name(shost),
 		      FC_SYMBOLIC_NAME_SIZE);
-	rspn_req->rspn.fr_name_len = len;
+	if (len != -E2BIG)
+		rspn_req->rspn.fr_name_len = len;
 
 	sg_init_one(&fc_req->sg_req, rspn_req, sizeof(*rspn_req));
 	sg_init_one(&fc_req->sg_rsp, rspn_rsp, sizeof(*rspn_rsp));
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f04352285155..676215cd8847 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1325,16 +1325,11 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
+	ssize_t len;
 	ssize_t ret;
 
-	len = strlcpy(buf, page, sizeof(buf));
-	if (len < sizeof(buf)) {
-		/* Strip any newline added from userspace. */
-		stripped = strstrip(buf);
-		len = strlen(stripped);
-	}
-	if (len > INQUIRY_VENDOR_LEN) {
+	len = strscpy(buf, page, sizeof(buf));
+	if (len == -E2BIG) {
 		pr_err("Emulated T10 Vendor Identification exceeds"
 			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
 			"\n");
@@ -1381,16 +1376,11 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_MODEL_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
+	ssize_t len;
 	ssize_t ret;
 
-	len = strlcpy(buf, page, sizeof(buf));
-	if (len < sizeof(buf)) {
-		/* Strip any newline added from userspace. */
-		stripped = strstrip(buf);
-		len = strlen(stripped);
-	}
-	if (len > INQUIRY_MODEL_LEN) {
+	len = strscpy(buf, page, sizeof(buf));
+	if (len == -E2BIG) {
 		pr_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
 			 __stringify(INQUIRY_MODEL_LEN)
 			"\n");
@@ -1437,16 +1427,11 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_REVISION_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
+	ssize_t len;
 	ssize_t ret;
 
-	len = strlcpy(buf, page, sizeof(buf));
-	if (len < sizeof(buf)) {
-		/* Strip any newline added from userspace. */
-		stripped = strstrip(buf);
-		len = strlen(stripped);
-	}
-	if (len > INQUIRY_REVISION_LEN) {
+	len = strscpy(buf, page, sizeof(buf));
+	if (len == -E2BIG) {
 		pr_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
 			 __stringify(INQUIRY_REVISION_LEN)
 			"\n");
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 78acc270e39a..c858aeb8fccf 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -2031,9 +2031,14 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 		ssize_t len = sizeof(user_kdgkb->kb_string);
 
 		spin_lock_irqsave(&func_buf_lock, flags);
-		len = strlcpy(kbs->kb_string, func_table[i] ? : "", len);
+		len = strscpy(kbs->kb_string, func_table[i] ? : "", len);
 		spin_unlock_irqrestore(&func_buf_lock, flags);
 
+		if (len == -E2BIG) {
+			ret = -E2BIG;
+			goto reterr;
+		}
+
 		ret = copy_to_user(user_kdgkb->kb_string, kbs->kb_string,
 				len + 1) ? -EFAULT : 0;
 
diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 19d97940eeb9..f9a50725a16f 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1135,11 +1135,11 @@ F_MIDI_OPT(out_ports, true, MAX_PORTS);
 static ssize_t f_midi_opts_id_show(struct config_item *item, char *page)
 {
 	struct f_midi_opts *opts = to_f_midi_opts(item);
-	int result;
+	ssize_t result;
 
 	mutex_lock(&opts->lock);
 	if (opts->id) {
-		result = strlcpy(page, opts->id, PAGE_SIZE);
+		result = strscpy(page, opts->id, PAGE_SIZE);
 	} else {
 		page[0] = 0;
 		result = 0;
diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index 64a4112068fc..7a185029f2e9 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1209,15 +1209,15 @@ static ssize_t f_printer_opts_pnp_string_show(struct config_item *item,
 					      char *page)
 {
 	struct f_printer_opts *opts = to_f_printer_opts(item);
-	int result = 0;
+	ssize_t result = 0;
 
 	mutex_lock(&opts->lock);
 	if (!opts->pnp_string)
 		goto unlock;
 
-	result = strlcpy(page, opts->pnp_string, PAGE_SIZE);
-	if (result >= PAGE_SIZE) {
-		result = PAGE_SIZE;
+	result = strscpy(page, opts->pnp_string, PAGE_SIZE);
+	if (result == -E2BIG) {
+		goto unlock;
 	} else if (page[result - 1] != '\n' && result + 1 < PAGE_SIZE) {
 		page[result++] = '\n';
 		page[result] = '\0';
diff --git a/drivers/usb/usbip/stub_main.c b/drivers/usb/usbip/stub_main.c
index c1c0bbc9f8b1..f38e41800782 100644
--- a/drivers/usb/usbip/stub_main.c
+++ b/drivers/usb/usbip/stub_main.c
@@ -169,15 +169,15 @@ static ssize_t match_busid_show(struct device_driver *drv, char *buf)
 static ssize_t match_busid_store(struct device_driver *dev, const char *buf,
 				 size_t count)
 {
-	int len;
+	ssize_t len;
 	char busid[BUSID_SIZE];
 
 	if (count < 5)
 		return -EINVAL;
 
 	/* busid needs to include \0 termination */
-	len = strlcpy(busid, buf + 4, BUSID_SIZE);
-	if (sizeof(busid) <= len)
+	len = strscpy(busid, buf + 4, BUSID_SIZE);
+	if (len == -E2BIG)
 		return -EINVAL;
 
 	if (!strncmp(buf, "add ", 4)) {
diff --git a/drivers/watchdog/diag288_wdt.c b/drivers/watchdog/diag288_wdt.c
index aafc8d98bf9f..5703f35dd0b7 100644
--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -111,7 +111,7 @@ static unsigned long wdt_status;
 static int wdt_start(struct watchdog_device *dev)
 {
 	char *ebc_cmd;
-	size_t len;
+	ssize_t len;
 	int ret;
 	unsigned int func;
 
@@ -126,7 +126,9 @@ static int wdt_start(struct watchdog_device *dev)
 			clear_bit(DIAG_WDOG_BUSY, &wdt_status);
 			return -ENOMEM;
 		}
-		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		len = strscpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		if (len == -E2BIG)
+			return -E2BIG;
 		ASCEBC(ebc_cmd, MAX_CMDLEN);
 		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
 
@@ -163,7 +165,7 @@ static int wdt_stop(struct watchdog_device *dev)
 static int wdt_ping(struct watchdog_device *dev)
 {
 	char *ebc_cmd;
-	size_t len;
+	ssize_t len;
 	int ret;
 	unsigned int func;
 
@@ -173,7 +175,9 @@ static int wdt_ping(struct watchdog_device *dev)
 		ebc_cmd = kmalloc(MAX_CMDLEN, GFP_KERNEL);
 		if (!ebc_cmd)
 			return -ENOMEM;
-		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		len = strscpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		if (len == -E2BIG)
+			return -E2BIG;
 		ASCEBC(ebc_cmd, MAX_CMDLEN);
 		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
 
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 9aec80b9d7c6..0eef6c3bc223 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -42,9 +42,9 @@ static bool kernfs_lockdep(struct kernfs_node *kn)
 static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
 {
 	if (!kn)
-		return strlcpy(buf, "(null)", buflen);
+		return strscpy(buf, "(null)", buflen);
 
-	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
+	return strscpy(buf, kn->parent ? kn->name : "/", buflen);
 }
 
 /* kernfs_node_depth - compute depth from @from to @to */
@@ -125,17 +125,18 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 {
 	struct kernfs_node *kn, *common;
 	const char parent_str[] = "/..";
-	size_t depth_from, depth_to, len = 0;
+	size_t depth_from, depth_to;
+	ssize_t len = 0;
 	int i, j;
 
 	if (!kn_to)
-		return strlcpy(buf, "(null)", buflen);
+		return strscpy(buf, "(null)", buflen);
 
 	if (!kn_from)
 		kn_from = kernfs_root(kn_to)->kn;
 
 	if (kn_from == kn_to)
-		return strlcpy(buf, "/", buflen);
+		return strscpy(buf, "/", buflen);
 
 	if (!buf)
 		return -EINVAL;
@@ -150,16 +151,16 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 	buf[0] = '\0';
 
 	for (i = 0; i < depth_from; i++)
-		len += strlcpy(buf + len, parent_str,
+		len += strscpy(buf + len, parent_str,
 			       len < buflen ? buflen - len : 0);
 
 	/* Calculate how many bytes we need for the rest */
 	for (i = depth_to - 1; i >= 0; i--) {
 		for (kn = kn_to, j = 0; j < i; j++)
 			kn = kn->parent;
-		len += strlcpy(buf + len, "/",
+		len += strscpy(buf + len, "/",
 			       len < buflen ? buflen - len : 0);
-		len += strlcpy(buf + len, kn->name,
+		len += strscpy(buf + len, kn->name,
 			       len < buflen ? buflen - len : 0);
 	}
 
@@ -173,8 +174,8 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
  * @buflen: size of @buf
  *
  * Copies the name of @kn into @buf of @buflen bytes.  The behavior is
- * similar to strlcpy().  It returns the length of @kn's name and if @buf
- * isn't long enough, it's filled upto @buflen-1 and nul terminated.
+ * similar to strscpy().  It returns the length of @kn's name and if @buf
+ * isn't long enough or @buflen is 0, it returns -E2BIG.
  *
  * Fills buffer with "(null)" if @kn is NULL.
  *
@@ -859,7 +860,7 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 					  const unsigned char *path,
 					  const void *ns)
 {
-	size_t len;
+	ssize_t len;
 	char *p, *name;
 
 	lockdep_assert_held(&kernfs_mutex);
@@ -867,9 +868,9 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 	/* grab kernfs_rename_lock to piggy back on kernfs_pr_cont_buf */
 	spin_lock_irq(&kernfs_rename_lock);
 
-	len = strlcpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
+	len = strscpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
 
-	if (len >= sizeof(kernfs_pr_cont_buf)) {
+	if (len == -E2BIG) {
 		spin_unlock_irq(&kernfs_rename_lock);
 		return NULL;
 	}
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e41c21819ba0..655c949cd898 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2268,7 +2268,7 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
 	} else {
 		/* if no hierarchy exists, everyone is in "/" */
-		ret = strlcpy(buf, "/", buflen);
+		ret = strscpy(buf, "/", buflen);
 	}
 
 	spin_unlock_irq(&css_set_lock);
diff --git a/kernel/module.c b/kernel/module.c
index a4fa44a652a7..7f3ee5fdeb93 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2777,6 +2777,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	Elf_Sym *dst;
 	char *s;
 	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
+	ssize_t len;
 
 	/* Set up to point into init section. */
 	mod->kallsyms = mod->init_layout.base + info->mod_kallsyms_init_off;
@@ -2804,8 +2805,9 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 			    mod->kallsyms->typetab[i];
 			dst[ndst] = src[i];
 			dst[ndst++].st_name = s - mod->core_kallsyms.strtab;
-			s += strlcpy(s, &mod->kallsyms->strtab[src[i].st_name],
+			len = strscpy(s, &mod->kallsyms->strtab[src[i].st_name],
 				     KSYM_NAME_LEN) + 1;
+			s += (len != -E2BIG) ? len : 0;
 		}
 	}
 	mod->core_kallsyms.num_symtab = ndst;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3cf7128e1ad3..f9583afdb735 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -154,12 +154,11 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
 	u8 *dst = get_loc_data(dest, base);
 	void __user *src = (void __force __user *) addr;
 
-	if (unlikely(!maxlen))
-		return -ENOMEM;
-
-	if (addr == FETCH_TOKEN_COMM)
-		ret = strlcpy(dst, current->comm, maxlen);
-	else
+	if (addr == FETCH_TOKEN_COMM) {
+		ret = strscpy(dst, current->comm, maxlen);
+		if (ret == -E2BIG)
+			return -ENOMEM;
+	} else
 		ret = strncpy_from_user(dst, src, maxlen);
 	if (ret >= 0) {
 		if (ret == maxlen)
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 7998affa45d4..9dca89b76a22 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -251,11 +251,11 @@ static int kobj_usermode_filter(struct kobject *kobj)
 
 static int init_uevent_argv(struct kobj_uevent_env *env, const char *subsystem)
 {
-	int len;
+	ssize_t len;
 
-	len = strlcpy(&env->buf[env->buflen], subsystem,
+	len = strscpy(&env->buf[env->buflen], subsystem,
 		      sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen)) {
+	if (len == -E2BIG) {
 		WARN(1, KERN_ERR "init_uevent_argv: buffer size too small\n");
 		return -ENOMEM;
 	}
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8c5ddffd707d..7dad41f0d3a1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9200,10 +9200,10 @@ EXPORT_SYMBOL_GPL(devlink_port_param_value_changed);
 void devlink_param_value_str_fill(union devlink_param_value *dst_val,
 				  const char *src)
 {
-	size_t len;
+	ssize_t len;
 
-	len = strlcpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
-	WARN_ON(len >= __DEVLINK_PARAM_MAX_STRING_VALUE);
+	len = strscpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	WARN_ON(len == -E2BIG);
 }
 EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 3259120462ed..3c55c76461c4 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -282,7 +282,7 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
 
 static void rpc_clnt_set_nodename(struct rpc_clnt *clnt, const char *nodename)
 {
-	clnt->cl_nodelen = strlcpy(clnt->cl_nodename,
+	clnt->cl_nodelen = strscpy(clnt->cl_nodename,
 			nodename, sizeof(clnt->cl_nodename));
 }
 
@@ -422,6 +422,10 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 		nodename = utsname()->nodename;
 	/* save the nodename */
 	rpc_clnt_set_nodename(clnt, nodename);
+	if (clnt->cl_nodelen == -E2BIG) {
+		err = -ENOMEM;
+		goto out_no_path;
+	}
 
 	err = rpc_client_register(clnt, args->authflavor, args->client_name);
 	if (err)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9b5adeaa47fc..7107f394992b 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -760,8 +760,14 @@ static int __init ima_init_arch_policy(void)
 	for (rules = arch_rules, i = 0; *rules != NULL; rules++) {
 		char rule[255];
 		int result;
+		ssize_t len;
 
-		result = strlcpy(rule, *rules, sizeof(rule));
+		len = strscpy(rule, *rules, sizeof(rule));
+		if (len == -E2BIG) {
+			pr_warn("Internal copy of architecture policy rule '%s' "
+				"failed. Skipping.\n", *rules);
+			continue;
+		}
 
 		INIT_LIST_HEAD(&arch_policy_entry[i].list);
 		result = ima_parse_rule(rule, &arch_policy_entry[i]);
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 4457214a3ae6..450a527f654b 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -494,7 +494,7 @@ static void usb_audio_make_longname(struct usb_device *dev,
 	struct snd_card *card = chip->card;
 	const struct usb_audio_device_name *preset;
 	const char *s = NULL;
-	int len;
+	ssize_t len;
 
 	preset = lookup_device_name(chip->usb_id);
 
@@ -511,7 +511,7 @@ static void usb_audio_make_longname(struct usb_device *dev,
 	else if (quirk && quirk->vendor_name)
 		s = quirk->vendor_name;
 	if (s && *s) {
-		len = strlcpy(card->longname, s, sizeof(card->longname));
+		len = strscpy(card->longname, s, sizeof(card->longname));
 	} else {
 		/* retrieve the vendor and device strings as longname */
 		if (dev->descriptor.iManufacturer)
-- 
2.29.2

