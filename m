Return-Path: <SRS0=utEW=CE=lists.openwall.com=kernel-hardening-return-19671-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55257C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 19:53:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 97245207BC
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 19:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="rRl+Udx0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97245207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19671-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8077 invoked by uid 550); 26 Aug 2020 19:52:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8055 invoked from network); 26 Aug 2020 19:52:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=VbJ9M0x7/6kdVUf5kyNPDEStbpnR2XDArodticGgnuw=;
        b=rRl+Udx0c/tGT5sCZv6zDX1U97/r6hjWIJ1etf9yfwwvdhzwi+WnMpG8Qgm/MUoHJn
         Ee4rGok0Wx4355BscUdPeV2RoMj6B5E9CiOF1MWXin/kkuRtjLAxhVt7FzOKKIYCnDBn
         wy38Xp0nqiwlcVZ3HoDTBTTB6GOwKFLhD1XGxB8Ud1p55FRo9REe8djvCD/9myaSshs3
         pjoSDjYgzeOQpVP3xPaYQ9LXXofKLVXT40825djtQaGq8HL3SUKL6UlGHfyYMFZ+v4zC
         bEhMqDfO7oUnl3LMOLhPUPzJnm4Zr4xu6TxhiveZ1ND+AULjsg25FkSiel1XDB2cxyNn
         l84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=VbJ9M0x7/6kdVUf5kyNPDEStbpnR2XDArodticGgnuw=;
        b=p8dfHigizw1R49bQ6uRhAZd2DaJRQyBW4sG4gCVMUD77BHQA1Q0kzwxhSNTz3rBnjV
         zjoSYQugqVZgy/4xu//SSAb0wnrjAPz0WiRybpTmZHPBNrsPFZnWm0uBGsuqz1yv5XAZ
         rpN9NVpPhal03Ju8yOIPJnWUevLLRbwdsxWZAWhlJL7e+DiMiUqkWM54r890kVwdqnhG
         itNMhvnPh1Z80gv0VNsjivIhj6z03ChkiLJ8CBZ3vQaYs0wKa/zvA6d5/7/whzL3eoKi
         XoAlMDYj4qa6LQKXdU9XWS+pXP5suerzd8kNYBrKlbSZq5fUlQvbpDu/i29PpkrIg/b3
         zhQA==
X-Gm-Message-State: AOAM530UDG1bg+9krHJ09XuInG57JU0TFGTcAIWluCiZmCvrBz8b1VWc
	k86yXVNQp/Mav7DulpkenOoEqg==
X-Google-Smtp-Source: ABdhPJz2tJUnfEf0SqTON1++961s4mS80Ys4vUdtGo5FqM5ZbNWVgz7JG4vIUMYBfxdhxOnPXyMo2A==
X-Received: by 2002:a62:f843:: with SMTP id c3mr13624152pfm.247.1598471562130;
        Wed, 26 Aug 2020 12:52:42 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <C1F49852-C886-4522-ACD6-DDBF7DE3B838@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_97ED6957-F79E-438A-BEE2-A42EA0D99B36";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Date: Wed, 26 Aug 2020 13:52:38 -0600
In-Reply-To: <202008261241.074D8765@keescook>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
 Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Jann Horn <jannh@google.com>,
 Jeff Moyer <jmoyer@redhat.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Sargun Dhillon <sargun@sargun.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Aleksa Sarai <asarai@suse.de>,
 io-uring@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com> <202008261241.074D8765@keescook>
X-Mailer: Apple Mail (2.3273)


--Apple-Mail=_97ED6957-F79E-438A-BEE2-A42EA0D99B36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Aug 26, 2020, at 1:43 PM, Kees Cook <keescook@chromium.org> wrote:
> 
> On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
>> The enumeration allows us to keep track of the last
>> io_uring_register(2) opcode available.
>> 
>> Behaviour and opcodes names don't change.
>> 
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>> include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>> 1 file changed, 16 insertions(+), 11 deletions(-)
>> 
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index d65fde732518..cdc98afbacc3 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -255,17 +255,22 @@ struct io_uring_params {
>> /*
>>  * io_uring_register(2) opcodes and arguments
>>  */
>> -#define IORING_REGISTER_BUFFERS		0
>> -#define IORING_UNREGISTER_BUFFERS	1
>> -#define IORING_REGISTER_FILES		2
>> -#define IORING_UNREGISTER_FILES		3
>> -#define IORING_REGISTER_EVENTFD		4
>> -#define IORING_UNREGISTER_EVENTFD	5
>> -#define IORING_REGISTER_FILES_UPDATE	6
>> -#define IORING_REGISTER_EVENTFD_ASYNC	7
>> -#define IORING_REGISTER_PROBE		8
>> -#define IORING_REGISTER_PERSONALITY	9
>> -#define IORING_UNREGISTER_PERSONALITY	10
>> +enum {
>> +	IORING_REGISTER_BUFFERS,
> 
> Actually, one *tiny* thought. Since this is UAPI, do we want to be extra
> careful here and explicitly assign values? We can't change the meaning
> of a number (UAPI) but we can add new ones, etc? This would help if an
> OP were removed (to stop from triggering a cascade of changed values)...
> 
> for example:
> 
> enum {
> 	IORING_REGISTER_BUFFERS = 0,
> 	IORING_UNREGISTER_BUFFERS = 1,
> 	...

Definitely that is preferred, IMHO, for enums used as part of UAPI,
as it avoids accidental changes to the values, and it also makes it
easier to see what the actual values are.

Cheers, Andreas






--Apple-Mail=_97ED6957-F79E-438A-BEE2-A42EA0D99B36
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl9GvYYACgkQcqXauRfM
H+CDqw/+M9+szTISRR0mIIv0L6q5oHSmmJFu6N4WmXH9ZZfUYkGvC7f4CTNhd2k5
mF1lXbrMAF4i2/0Aui4WjWC5UoW77PBFwOpPYrTw/dbF16AbXEw1HoFamlgZ1Ote
APczb6wzuFTYYdN9rgX+jdSDUBnvjmdomJz++4ZmScTqTOzUHBkgIS7O4Lw+O6o/
Hu9oXp/VS3WvHQyDFYFAuaUR+UPAUeOec4AXfRNbC0RdadsFKtNZKI5p3VV16I3v
v5M9vGUxH/bweRVwBe7w2J0X0mQvtOKwXYVEFxpUrIHIMMzxBKx1FY8KbMpudyPB
lgECtvuCo+fDQrEMZ7xaE8xclFQa0ts/YnHFi9qrPHH0AvtNY+zA//OQjBNm06tc
t8uKkMnPuxWDv5krYrFZhtM9DM/YKJrdSf4Bq08u9aiRKYkE0HgoS3J7pZ9Vq2Kz
+d2RFoEm0cpZMW5ut7jbcXO1tW1RnXadKCkvoVcYZ2yK+WytE5Y+S5vXg7jtLpML
PKKWgX6hxJPQ3Nz+DOQGvnNQ/Xr0eT7BF2d9BSu2q5B4+s+NPKLunjnFZaWiAq5g
Y2okqZKRc2hdkb+fAG0Qn3dTLJ/PooXW2V0zaTGI7Nx7KgqaAI+w/mb8TX48BhAk
ZCjtvI/znZFgtzZjuDIfSa1pN2K2VJPBYla1Bdrx7r+CEhA7mEY=
=gPQ0
-----END PGP SIGNATURE-----

--Apple-Mail=_97ED6957-F79E-438A-BEE2-A42EA0D99B36--
