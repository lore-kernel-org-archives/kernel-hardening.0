Subject: Re: [PATCH] drivers: net: wireless: ath: ath9k: dfs: remove VLA usage
References: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com>
From: Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fb0bb0e5-e037-e006-ca11-45eb8a8aa1b7@gmail.com>
Date: Fri, 9 Mar 2018 05:34:36 -0800
MIME-Version: 1.0
In-Reply-To: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andreas Christoforou <andreaschristofo@gmail.com>, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 03/09/2018 05:23 AM, Andreas Christoforou wrote:
> The kernel would like to have all stack VLA usage removed.
> 
> This is the correct patch.
> 
> Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>

This is a lazy changelog really.

'This is the correct patch' has no technical value.

What is VLA  ? Sure, _now_ its pretty clear since we have floods of 
these patches, but...

In one or two years, people reading it will not understand the logic of 
this patch.

I had to look at the source to understand what was going on, and that is 
not a good sign for a trivial patch like that.
