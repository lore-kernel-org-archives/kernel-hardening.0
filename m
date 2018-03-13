Date: Tue, 13 Mar 2018 01:35:40 +0100
From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH 0/2] Remove VLA usage in rtc-s5m
Message-ID: <20180313003540.GF3795@piout.net>
References: <cover.1520660422.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1520660422.git.gustavo@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alessandro Zummo <a.zummo@towertech.it>, Lee Jones <lee.jones@linaro.org>, linux-samsung-soc@vger.kernel.org, linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 10/03/2018 at 00:27:02 -0600, Gustavo A. R. Silva wrote:
> This patchset aims to remove VLA usage from rtc-s5m.
> 
> The first patch moves an enum from rtc.h to rtc-s5m.c, as this is the
> only driver in which such enum is actually being used [1].
> 
> The second patch adds the enum name RTC_MAX_NUM_TIME_REGS, which will
> be used as a maximum length to the current VLAs, hence turning them
> into fixed-length arrays instead.
> 
> [1] https://marc.info/?l=linux-rtc&m=152060068925948&w=2
> 
> Thanks
> 
> Gustavo A. R. Silva (2):
>   rtc: s5m: move enum from rtc.h to rtc-s5m.c
>   rtc: s5m: Remove VLA usage
> 

Both applied, thanks.

-- 
Alexandre Belloni, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
