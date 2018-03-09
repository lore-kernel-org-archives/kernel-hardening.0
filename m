From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9k: dfs: remove VLA usage
References: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com>
Date: Fri, 09 Mar 2018 16:50:05 +0200
In-Reply-To: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com>
	(Andreas Christoforou's message of "Fri, 9 Mar 2018 15:23:53 +0200")
Message-ID: <87zi3hcnhe.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Andreas Christoforou <andreaschristofo@gmail.com>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Andreas Christoforou <andreaschristofo@gmail.com> writes:

> The kernel would like to have all stack VLA usage removed.
>
> This is the correct patch.
>
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>

Please use versioning in the patches:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

-- 
Kalle Valo
