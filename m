References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org> <1495724872.20270.46.camel@redhat.com>
 <8537bt9bvj.fsf@boum.org> <1495727974.20270.48.camel@redhat.com>
 <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
 <CAFwXZv_Nb5Q8n1kobbxz7+3w4r6pt-fD5YR4jw6_ZeXk1__9+A@mail.gmail.com>
 <20170526123416.GA26899@bifrost>
From: HacKurx <hackurx@gmail.com>
Message-ID: <c3ae85ab-539f-daa1-e318-3175b674d4a2@gmail.com>
Date: Fri, 9 Jun 2017 14:00:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170526123416.GA26899@bifrost>
Content-Type: multipart/alternative;
 boundary="------------FF813D668A24B27D7C0DE04B"
Subject: Re: [kernel-hardening] Patch for random mac address
To: Anisse Astier <anisse@astier.eu>
Cc: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, intrigeri <intrigeri@boum.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is a multi-part message in MIME format.
--------------FF813D668A24B27D7C0DE04B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Le 26/05/2017 à 14:34, Anisse Astier a écrit :
> On Fri, May 26, 2017 at 09:55:37AM +0200, HacKurx wrote:
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index fca407b..3eeb42b 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6669,6 +6669,26 @@ int dev_change_flags(struct net_device *dev, unsigned int flags)
>>  
>>  	changes = (old_flags ^ dev->flags) | (old_gflags ^ dev->gflags);
>>  	__dev_notify_flags(dev, old_flags, changes);
>> +
>> +#ifdef CONFIG_RANDOM_MAC_ADDRESS
>> +	if ((changes & IFF_UP) && !(old_flags & IFF_UP)) {
>> +		/* randomize MAC whenever interface is brought up */
>> +		struct sockaddr sa;
>> +		unsigned int mac4;
>> +		unsigned short mac2;
>> +
>> +		mac4 = prandom_u32();
>> +		mac2 = prandom_u32();
>> +		memcpy(sa.sa_data, &mac4, sizeof(mac4));
>> +		memcpy((char *)sa.sa_data + sizeof(mac4), &mac2, sizeof(mac2));
>> +		if (!is_valid_ether_addr(sa.sa_data))
>> +			sa.sa_data[5] = 1;
>> +		sa.sa_data[0] &= 0xFC;
>> +		sa.sa_family = dev->type;
>> +		dev_set_mac_address(dev, &sa);
> You didn't answer my question regarding why this is different from the
> function eth_random_addr.
What do you think by replacing the whole by that?

+#ifdef CONFIG_RANDOM_MAC_ADDRESS
+    /* randomize MAC whenever interface is brought up */
+    if ((changes & IFF_UP) && !(old_flags & IFF_UP)) {
+        struct sockaddr sa;
+        eth_random_addr(sa.sa_data);
+        sa.sa_family = dev->type;
+        dev_set_mac_address(dev, &sa);

The network doesn't work with "eth_hw_addr_random(dev);" (the change of MAC addresses works well). Do you know why ?
Because the eth_hw_addr_randomfunction works better on all types of network cards.

Thanks,

Loic

--------------FF813D668A24B27D7C0DE04B
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Le 26/05/2017 à 14:34, Anisse Astier a écrit :<br>
    <blockquote type="cite" cite="mid:20170526123416.GA26899@bifrost">
      <pre wrap="">On Fri, May 26, 2017 at 09:55:37AM +0200, HacKurx wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">diff --git a/net/core/dev.c b/net/core/dev.c
index fca407b..3eeb42b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6669,6 +6669,26 @@ int dev_change_flags(struct net_device *dev, unsigned int flags)
 
 	changes = (old_flags ^ dev-&gt;flags) | (old_gflags ^ dev-&gt;gflags);
 	__dev_notify_flags(dev, old_flags, changes);
+
+#ifdef CONFIG_RANDOM_MAC_ADDRESS
+	if ((changes &amp; IFF_UP) &amp;&amp; !(old_flags &amp; IFF_UP)) {
+		/* randomize MAC whenever interface is brought up */
+		struct sockaddr sa;
+		unsigned int mac4;
+		unsigned short mac2;
+
+		mac4 = prandom_u32();
+		mac2 = prandom_u32();
+		memcpy(sa.sa_data, &amp;mac4, sizeof(mac4));
+		memcpy((char *)sa.sa_data + sizeof(mac4), &amp;mac2, sizeof(mac2));
+		if (!is_valid_ether_addr(sa.sa_data))
+			sa.sa_data[5] = 1;
+		sa.sa_data[0] &amp;= 0xFC;
+		sa.sa_family = dev-&gt;type;
+		dev_set_mac_address(dev, &amp;sa);
</pre>
      </blockquote>
      <pre wrap="">
You didn't answer my question regarding why this is different from the
function eth_random_addr.
</pre>
    </blockquote>
    <span id="result_box" class="short_text" lang="en"><span class="">What
        do you think by replacing the whole by that?</span></span><br>
    <span id="result_box" class="short_text" lang="en"><span class=""></span></span><br>
    +#ifdef CONFIG_RANDOM_MAC_ADDRESS<br>
    +    /* randomize MAC whenever interface is brought up */<br>
    +    if ((changes &amp; IFF_UP) &amp;&amp; !(old_flags &amp;
    IFF_UP)) {<br>
    +        struct sockaddr sa;<br>
    +        eth_random_addr(sa.sa_data);<br>
    +        sa.sa_family = dev-&gt;type;<br>
    +        dev_set_mac_address(dev, &amp;sa);<br>
    <br>
    The network doesn't work with "eth_hw_addr_random(dev);" (the change
    of MAC addresses works well). <span id="result_box"
      class="short_text" lang="en"><span class="">Do you know why ?</span></span><br>
    Because the eth_hw_addr_random<span id="result_box" class=""
      lang="en"><span class=""><span id="result_box" class="short_text"
          lang="en"><span class=""> function </span></span>works better
        on all types of network cards.<br>
        <br>
        Thanks,<br>
        <br>
        Loic<br>
      </span></span>
  </body>
</html>

--------------FF813D668A24B27D7C0DE04B--
