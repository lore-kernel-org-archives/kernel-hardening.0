MIME-Version: 1.0
In-Reply-To: <1520602169.26370.1.camel@perches.com>
References: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com> <1520602169.26370.1.camel@perches.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 9 Mar 2018 07:42:02 -0800
Message-ID: <CAKxU2N8wULJyidq9BiU_87o7csS=HcKjAa7DCX7vuGRiLJdbcw@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9k: dfs: remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Joe Perches <joe@perches.com>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, keescook@chromium.org, kernel-hardening@lists.openwall.com, QCA ath9k Development <ath9k-devel@qca.qualcomm.com>, Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 5:29 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2018-03-09 at 15:23 +0200, Andreas Christoforou wrote:
>> The kernel would like to have all stack VLA usage removed.
>> This is the correct patch.
> []
>> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
> []
>> @@ -101,7 +101,7 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
>>                                int datalen, bool is_ctl, bool is_ext)
>>  {
>>       int i;
>> -     int max_bin[FFT_NUM_SAMPLES];
>> +     int max_bin[NUM_DIFFS + 1];
>>       struct ath_hw *ah = sc->sc_ah;
>>       struct ath_common *common = ath9k_hw_common(ah);
>>       int prev_delta;
>
> why not just change FFT_NUM_SAMPLES to a #define
> or get rid if FFT_NUM_SAMPLES altogether?
>
I did the former yesterday. Never submitted.
> $ git grep -w FFT_NUM_SAMPLES
> drivers/net/wireless/ath/ath9k/dfs.c:static const int FFT_NUM_SAMPLES   = (NUM_DIFFS + 1);
> drivers/net/wireless/ath/ath9k/dfs.c:   int max_bin[FFT_NUM_SAMPLES];
> drivers/net/wireless/ath/ath9k/dfs.c:           if (num_fft_packets < (FFT_NUM_SAMPLES)) {
> drivers/net/wireless/ath/ath9k/dfs.c:           for (i = 0; i < FFT_NUM_SAMPLES; i++)
> drivers/net/wireless/ath/ath9k/dfs.c:           if (num_fft_packets < (FFT_NUM_SAMPLES)) {
> drivers/net/wireless/ath/ath9k/dfs.c:           for (i = 0; i < FFT_NUM_SAMPLES; i++)
