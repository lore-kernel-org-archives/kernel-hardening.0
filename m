MIME-Version: 1.0
In-Reply-To: <5AA464DE.90100@broadcom.com>
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com> <5AA464DE.90100@broadcom.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 10 Mar 2018 18:44:35 -0500
Message-ID: <CA+DvKQ+hbMoWJdOuQB5n+eVF4ePf=kVuRiMbdtTUZ8ars4Pz4A@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Just wondering. Is this actually a VLA. FFT_NUM_SAMPLES was static const so
> not really going to show a lot of variation. This array will always have the
> same size on the stack.

The issue is that unlike in C++, a `static const` can't be used in a
constant expression in C. It's unclear why C is defined that way but
it's how it is and there isn't currently a GCC extension making more
things into constant expressions like C++.
