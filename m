Return-Path: <SRS0=aJNv=XV=lists.openwall.com=kernel-hardening-return-16938-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04B0C432C2
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 00:02:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 88A5421D6C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 00:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88A5421D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16938-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15564 invoked by uid 550); 26 Sep 2019 00:02:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15532 invoked from network); 26 Sep 2019 00:02:13 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 26 Sep 2019 02:01:47 +0200
From: Stephen Kitt <steve@sk2.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Jonathan
 Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Nitin Gote
 <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com, Rasmus Villemoes
 <rasmus.villemoes@prevas.dk>, Takashi Iwai <tiwai@suse.com>, Clemens Ladisch
 <clemens@ladisch.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
In-Reply-To: <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
References: <cover.1563889130.git.joe@perches.com>
 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
 <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
Message-ID: <c0c2b8f6ac9f257b102b5a1a4b4dc949@sk2.org>
X-Sender: steve@sk2.org
User-Agent: Roundcube Webmail/1.3.10
X-Originating-IP: 37.165.176.206
X-Webmail-UserID: steve@sk2.org
X-Ovh-Tracer-Id: 18444773749440531955
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrfeefgddvkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd

Le 25/09/2019 23:50, Andrew Morton a écrit :
> On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:
> 
>> Several uses of strlcpy and strscpy have had defects because the
>> last argument of each function is misused or typoed.
>> 
>> Add macro mechanisms to avoid this defect.
>> 
>> stracpy (copy a string to a string array) must have a string
>> array as the first argument (dest) and uses sizeof(dest) as the
>> count of bytes to copy.
>> 
>> These mechanisms verify that the dest argument is an array of
>> char or other compatible types like u8 or s8 or equivalent.
>> 
>> A BUILD_BUG is emitted when the type of dest is not compatible.
>> 
> 
> I'm still reluctant to merge this because we don't have code in -next
> which *uses* it.  You did have a patch for that against v1, I believe?
> Please dust it off and send it along?

Joe had a Coccinelle script to mass-convert strlcpy and strscpy.
Here's a different patch which converts some of ALSA's strcpy calls to
stracpy:


 From 89e9afa562f3351bc000f3aacb1041eafbe0204c Mon Sep 17 00:00:00 2001
 From: Stephen Kitt <steve@sk2.org>
Date: Thu, 26 Sep 2019 01:36:20 +0200
Subject: [PATCH] ALSA: use stracpy in docs, USB and Intel HDMI

This converts the Writing an ALSA driver manual to stracpy instead of
strcpy, and applies the change to the USB drivers and the Intel HDMI
audio driver.

Using stracpy ensures that the target is a char array and that the
copy doesn't overflow (using strscpy).

(This requires Joe Perches' stracpy patch.)

Signed-off-by: Stephen Kitt <steve@sk2.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
  .../sound/kernel-api/writing-an-alsa-driver.rst  | 16 ++++++++--------
  sound/usb/6fire/chip.c                           |  4 ++--
  sound/usb/6fire/midi.c                           |  2 +-
  sound/usb/6fire/pcm.c                            |  2 +-
  sound/usb/card.c                                 |  2 +-
  sound/usb/line6/driver.c                         |  8 ++++----
  sound/usb/line6/midi.c                           |  4 ++--
  sound/usb/line6/pcm.c                            |  2 +-
  sound/usb/line6/toneport.c                       |  4 ++--
  sound/usb/midi.c                                 |  2 +-
  sound/usb/misc/ua101.c                           |  6 +++---
  sound/usb/mixer.c                                |  2 +-
  sound/usb/stream.c                               |  2 +-
  sound/usb/usx2y/us122l.c                         |  2 +-
  sound/usb/usx2y/usX2Yhwdep.c                     |  2 +-
  sound/usb/usx2y/usbusx2y.c                       |  4 ++--
  sound/x86/intel_hdmi_audio.c                     |  6 +++---
  17 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst 
b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
index 132f5eb9b530..90170d853a35 100644
--- a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
+++ b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
@@ -321,8 +321,8 @@ to details explained in the following section.
                        goto error;

                /* (4) */
-              strcpy(card->driver, "My Chip");
-              strcpy(card->shortname, "My Own Chip 123");
+              stracpy(card->driver, "My Chip");
+              stracpy(card->shortname, "My Own Chip 123");
                sprintf(card->longname, "%s at 0x%lx irq %i",
                        card->shortname, chip->port, chip->irq);

@@ -434,8 +434,8 @@ Since each component can be properly freed, the 
single

  ::

-  strcpy(card->driver, "My Chip");
-  strcpy(card->shortname, "My Own Chip 123");
+  stracpy(card->driver, "My Chip");
+  stracpy(card->shortname, "My Own Chip 123");
    sprintf(card->longname, "%s at 0x%lx irq %i",
            card->shortname, chip->port, chip->irq);

@@ -1373,7 +1373,7 @@ shows only the skeleton, how to build up the PCM 
interfaces.
                if (err < 0)
                        return err;
                pcm->private_data = chip;
-              strcpy(pcm->name, "My Chip");
+              stracpy(pcm->name, "My Chip");
                chip->pcm = pcm;
                /* set operators */
                snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
@@ -1406,7 +1406,7 @@ function. It would be better to create a 
constructor for pcm, namely,
            if (err < 0)
                    return err;
            pcm->private_data = chip;
-          strcpy(pcm->name, "My Chip");
+          stracpy(pcm->name, "My Chip");
            chip->pcm = pcm;
  	  ....
            return 0;
@@ -2590,7 +2590,7 @@ the string for the currently given item index.
            uinfo->value.enumerated.items = 4;
            if (uinfo->value.enumerated.item > 3)
                    uinfo->value.enumerated.item = 3;
-          strcpy(uinfo->value.enumerated.name,
+          stracpy(uinfo->value.enumerated.name,
                   texts[uinfo->value.enumerated.item]);
            return 0;
    }
@@ -3136,7 +3136,7 @@ function:
    if (err < 0)
            return err;
    rmidi->private_data = chip;
-  strcpy(rmidi->name, "My MIDI");
+  stracpy(rmidi->name, "My MIDI");
    rmidi->info_flags = SNDRV_RAWMIDI_INFO_OUTPUT |
                        SNDRV_RAWMIDI_INFO_INPUT |
                        SNDRV_RAWMIDI_INFO_DUPLEX;
diff --git a/sound/usb/6fire/chip.c b/sound/usb/6fire/chip.c
index 08c6e6a52eb9..a6e2ca0e1059 100644
--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -126,8 +126,8 @@ static int usb6fire_chip_probe(struct usb_interface 
*intf,
  		dev_err(&intf->dev, "cannot create alsa card.\n");
  		return ret;
  	}
-	strcpy(card->driver, "6FireUSB");
-	strcpy(card->shortname, "TerraTec DMX6FireUSB");
+	stracpy(card->driver, "6FireUSB");
+	stracpy(card->shortname, "TerraTec DMX6FireUSB");
  	sprintf(card->longname, "%s at %d:%d", card->shortname,
  			device->bus->busnum, device->devnum);

diff --git a/sound/usb/6fire/midi.c b/sound/usb/6fire/midi.c
index de2691d58de6..77700d331b21 100644
--- a/sound/usb/6fire/midi.c
+++ b/sound/usb/6fire/midi.c
@@ -183,7 +183,7 @@ int usb6fire_midi_init(struct sfire_chip *chip)
  		return ret;
  	}
  	rt->instance->private_data = rt;
-	strcpy(rt->instance->name, "DMX6FireUSB MIDI");
+	stracpy(rt->instance->name, "DMX6FireUSB MIDI");
  	rt->instance->info_flags = SNDRV_RAWMIDI_INFO_OUTPUT |
  			SNDRV_RAWMIDI_INFO_INPUT |
  			SNDRV_RAWMIDI_INFO_DUPLEX;
diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index 88ac1c4ee163..70b6f13641f7 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -656,7 +656,7 @@ int usb6fire_pcm_init(struct sfire_chip *chip)
  	}

  	pcm->private_data = rt;
-	strcpy(pcm->name, "DMX 6Fire USB");
+	stracpy(pcm->name, "DMX 6Fire USB");
  	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &pcm_ops);
  	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &pcm_ops);

diff --git a/sound/usb/card.c b/sound/usb/card.c
index db91dc76cc91..34062d65f030 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -486,7 +486,7 @@ static int snd_usb_audio_create(struct usb_interface 
*intf,

  	card->private_free = snd_usb_audio_free;

-	strcpy(card->driver, "USB-Audio");
+	stracpy(card->driver, "USB-Audio");
  	sprintf(component, "USB%04x:%04x",
  		USB_ID_VENDOR(chip->usb_id), USB_ID_PRODUCT(chip->usb_id));
  	snd_component_add(card, component);
diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index b5a3f754a4f1..c18dba368551 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -663,7 +663,7 @@ static int line6_hwdep_init(struct usb_line6 *line6)
  	err = snd_hwdep_new(line6->card, "config", 0, &hwdep);
  	if (err < 0)
  		goto end;
-	strcpy(hwdep->name, "config");
+	stracpy(hwdep->name, "config");
  	hwdep->iface = SNDRV_HWDEP_IFACE_LINE6;
  	hwdep->ops = hwdep_ops;
  	hwdep->private_data = line6;
@@ -751,9 +751,9 @@ int line6_probe(struct usb_interface *interface,
  	line6->ifcdev = &interface->dev;
  	INIT_DELAYED_WORK(&line6->startup_work, line6_startup_work);

-	strcpy(card->id, properties->id);
-	strcpy(card->driver, driver_name);
-	strcpy(card->shortname, properties->name);
+	stracpy(card->id, properties->id);
+	stracpy(card->driver, driver_name);
+	stracpy(card->shortname, properties->name);
  	sprintf(card->longname, "Line 6 %s at USB %s", properties->name,
  		dev_name(line6->ifcdev));
  	card->private_free = line6_destruct;
diff --git a/sound/usb/line6/midi.c b/sound/usb/line6/midi.c
index ba0e2b7e8fe1..fd1c2248c2ef 100644
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -226,8 +226,8 @@ static int snd_line6_new_midi(struct usb_line6 
*line6,
  		return err;

  	rmidi = *rmidi_ret;
-	strcpy(rmidi->id, line6->properties->id);
-	strcpy(rmidi->name, line6->properties->name);
+	stracpy(rmidi->id, line6->properties->id);
+	stracpy(rmidi->name, line6->properties->name);

  	rmidi->info_flags =
  	    SNDRV_RAWMIDI_INFO_OUTPUT |
diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index f70211e6b174..66cebbc0d18a 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -493,7 +493,7 @@ static int snd_line6_new_pcm(struct usb_line6 
*line6, struct snd_pcm **pcm_ret)
  	if (err < 0)
  		return err;
  	pcm = *pcm_ret;
-	strcpy(pcm->name, line6->properties->name);
+	stracpy(pcm->name, line6->properties->name);

  	/* set operators */
  	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
diff --git a/sound/usb/line6/toneport.c b/sound/usb/line6/toneport.c
index d0a555dbe324..ec704485861c 100644
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -198,8 +198,8 @@ static int snd_toneport_source_info(struct 
snd_kcontrol *kcontrol,
  	if (uinfo->value.enumerated.item >= size)
  		uinfo->value.enumerated.item = size - 1;

-	strcpy(uinfo->value.enumerated.name,
-	       toneport_source_info[uinfo->value.enumerated.item].name);
+	stracpy(uinfo->value.enumerated.name,
+		toneport_source_info[uinfo->value.enumerated.item].name);

  	return 0;
  }
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index b737f0ec77d0..4e8ec3a6db6f 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -2245,7 +2245,7 @@ static int snd_usbmidi_create_rawmidi(struct 
snd_usb_midi *umidi,
  			      out_ports, in_ports, &rmidi);
  	if (err < 0)
  		return err;
-	strcpy(rmidi->name, umidi->card->shortname);
+	stracpy(rmidi->name, umidi->card->shortname);
  	rmidi->info_flags = SNDRV_RAWMIDI_INFO_OUTPUT |
  			    SNDRV_RAWMIDI_INFO_INPUT |
  			    SNDRV_RAWMIDI_INFO_DUPLEX;
diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 307b72d5fffa..37531aa55450 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1267,8 +1267,8 @@ static int ua101_probe(struct usb_interface 
*interface,
  		goto probe_error;

  	name = usb_id->idProduct == 0x0044 ? "UA-1000" : "UA-101";
-	strcpy(card->driver, "UA-101");
-	strcpy(card->shortname, name);
+	stracpy(card->driver, "UA-101");
+	stracpy(card->shortname, name);
  	usb_make_path(ua->dev, usb_path, sizeof(usb_path));
  	snprintf(ua->card->longname, sizeof(ua->card->longname),
  		 "EDIROL %s (serial %s), %u Hz at %s, %s speed", name,
@@ -1293,7 +1293,7 @@ static int ua101_probe(struct usb_interface 
*interface,
  	if (err < 0)
  		goto probe_error;
  	ua->pcm->private_data = ua;
-	strcpy(ua->pcm->name, name);
+	stracpy(ua->pcm->name, name);
  	snd_pcm_set_ops(ua->pcm, SNDRV_PCM_STREAM_PLAYBACK, 
&playback_pcm_ops);
  	snd_pcm_set_ops(ua->pcm, SNDRV_PCM_STREAM_CAPTURE, &capture_pcm_ops);

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 3fd1d1749edf..3d123163c78e 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3408,7 +3408,7 @@ int snd_usb_create_mixer(struct snd_usb_audio 
*chip, int ctrlif,
  	struct usb_mixer_interface *mixer;
  	int err;

-	strcpy(chip->card->mixername, "USB Mixer");
+	stracpy(chip->card->mixername, "USB Mixer");

  	mixer = kzalloc(sizeof(*mixer), GFP_KERNEL);
  	if (!mixer)
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 11785f9652ad..1969763c88db 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -531,7 +531,7 @@ static int __snd_usb_add_audio_stream(struct 
snd_usb_audio *chip,
  	if (chip->pcm_devs > 0)
  		sprintf(pcm->name, "USB Audio #%d", chip->pcm_devs);
  	else
-		strcpy(pcm->name, "USB Audio");
+		stracpy(pcm->name, "USB Audio");

  	snd_usb_init_substream(as, stream, fp, pd);

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index e82c5236482d..c5f09b382e2b 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -539,7 +539,7 @@ static int usx2y_create_card(struct usb_device 
*device,
  	init_waitqueue_head(&US122L(card)->sk.sleep);
  	US122L(card)->is_us144 = flags & US122L_FLAG_US144;
  	INIT_LIST_HEAD(&US122L(card)->midi_list);
-	strcpy(card->driver, "USB "NAME_ALLCAPS"");
+	stracpy(card->driver, "USB "NAME_ALLCAPS"");
  	sprintf(card->shortname, "TASCAM "NAME_ALLCAPS"");
  	sprintf(card->longname, "%s (%x:%x if %d at %03d/%03d)",
  		card->shortname,
diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index d1caa8ed9e68..72ca8dba0f5b 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -115,7 +115,7 @@ static int snd_usX2Y_hwdep_dsp_status(struct 
snd_hwdep *hw,
  	}
  	if (0 > id)
  		return -ENODEV;
-	strcpy(info->id, type_ids[id]);
+	stracpy(info->id, type_ids[id]);
  	info->num_dsps = 2;		// 0: Prepad Data, 1: FPGA Code
  	if (us428->chip_status & USX2Y_STAT_CHIP_INIT)
  		info->chip_ready = 1;
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index c54158146917..b0b94d2884f4 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -347,8 +347,8 @@ static int usX2Y_create_card(struct usb_device 
*device,
  	init_waitqueue_head(&usX2Y(card)->prepare_wait_queue);
  	mutex_init(&usX2Y(card)->pcm_mutex);
  	INIT_LIST_HEAD(&usX2Y(card)->midi_list);
-	strcpy(card->driver, "USB "NAME_ALLCAPS"");
-	sprintf(card->shortname, "TASCAM "NAME_ALLCAPS"");
+	stracpy(card->driver, "USB "NAME_ALLCAPS"");
+	stracpy(card->shortname, "TASCAM "NAME_ALLCAPS"");
  	sprintf(card->longname, "%s (%x:%x if %d at %03d/%03d)",
  		card->shortname,
  		le16_to_cpu(device->descriptor.idVendor),
diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 5fd4e32247a6..f312e382e3e0 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1728,9 +1728,9 @@ static int hdmi_lpe_audio_probe(struct 
platform_device *pdev)
  	card_ctx = card->private_data;
  	card_ctx->dev = &pdev->dev;
  	card_ctx->card = card;
-	strcpy(card->driver, INTEL_HAD);
-	strcpy(card->shortname, "Intel HDMI/DP LPE Audio");
-	strcpy(card->longname, "Intel HDMI/DP LPE Audio");
+	stracpy(card->driver, INTEL_HAD);
+	stracpy(card->shortname, "Intel HDMI/DP LPE Audio");
+	stracpy(card->longname, "Intel HDMI/DP LPE Audio");

  	card_ctx->irq = -1;

-- 
2.20.1


(And yes, there's more to fix in the string handling here; I focused
on stracpy only.)

Regards,

Stephen
