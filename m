Subject: Re: [PATCH v2] aic7xxx/aic79xx: remove VLAs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <CAGXu5jK=JhBFHBGpbWF46DC3-QMruiB0qqz1z+njcK2h7jVU9w@mail.gmail.com>
	<20180308205158.5130-1-steve@sk2.org>
Date: Thu, 15 Mar 2018 00:35:16 -0400
In-Reply-To: <20180308205158.5130-1-steve@sk2.org> (Stephen Kitt's message of
	"Thu, 8 Mar 2018 21:51:58 +0100")
Message-ID: <yq1d1067y7v.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Stephen Kitt <steve@sk2.org>
Cc: hare@suse.com, keescook@chromium.org, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Stephen,

> In preparation to enabling -Wvla, remove VLAs and replace them with
> fixed-length arrays instead.
>
> The arrays fixed here, using the number of constant sections, aren't
> really VLAs, but they appear so to the compiler. Replace the array
> sizes with a pre-processor-level constant instead using ARRAY_SIZE.

Applied to 4.17/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
