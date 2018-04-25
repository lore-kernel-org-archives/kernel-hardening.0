MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87po2nagrk.fsf@kamboji.qca.qualcomm.com>
References: <20180424235752.GA37317@beast> <87po2nagrk.fsf@kamboji.qca.qualcomm.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Apr 2018 07:42:25 -0700
Message-ID: <CAGXu5jJrd94=RQJHqfdP9wTfhsp61+aCnOmr06bia3mmi79_Mg@mail.gmail.com>
Subject: Re: [PATCH v3] ath9k: dfs: Remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, Rosen Penev <rosenp@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>, linux-wireless <linux-wireless@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 25, 2018 at 12:26 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> I have already applied an almost identical patch:
>
> ath9k: dfs: remove accidental use of stack VLA
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=9c27489a34548913baaaf3b2776e05d4a9389e3e

Ah! Cool, no worries. I didn't see that in linux-next yet. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
