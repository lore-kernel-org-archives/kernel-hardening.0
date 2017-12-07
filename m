References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-3-git-send-email-alex.popov@linux.com>
 <15d83270-7a91-436f-1aab-0f6001954f4a@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <b693b0d5-ff37-f8df-444d-db389566a75b@linux.com>
Date: Fri, 8 Dec 2017 02:05:20 +0300
MIME-Version: 1.0
In-Reply-To: <15d83270-7a91-436f-1aab-0f6001954f4a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v6 2/6] gcc-plugins: Add STACKLEAK plugin for tracking
 the kernel stack
To: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06.12.2017 21:57, Laura Abbott wrote:
> On 12/05/2017 03:33 PM, Alexander Popov wrote:
>> +	/* Parse the plugin arguments */
>> +	if (argc != 1) {
>> +		error(G_("bad number of the plugin arguments: %d"), argc);
>> +		return 1;
>> +	}
>> +
>> +	if (strcmp(argv[i].key, "track-min-size")) {
>> +		error(G_("unknown option '-fplugin-arg-%s-%s'"),
>> +				plugin_name, argv[i].key);
>> +		return 1;
>> +	}
>> +
>> +	if (!argv[i].value) {
>> +		error(G_("no value supplied for option '-fplugin-arg-%s-%s'"),
>> +				plugin_name, argv[i].key);
>> +		return 1;
>> +	}
>> +
>> +	track_frame_size = atoi(argv[i].value);
>> +	if (track_frame_size < 0) {
>> +		error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"),
>> +				plugin_name, argv[i].key, argv[i].value);
>> +		return 1;
>> +	}
> 
> I don't see i getting updated anywhere, which seems to be an artifact of
> removing the for loop. I'd prefer if you just kept the loop since the
> arm64 version requires a --disable option like structleak.

Ok, no problem, I'll return the loop and add --disable option in v7.

Best regards,
Alexander
