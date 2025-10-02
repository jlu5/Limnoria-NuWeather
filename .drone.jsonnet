local supybot_test(py_version) = {
    kind: "pipeline",
    type: "docker",
    name: "py" + py_version,

    steps: [
        {
            name: "test",
            image: "python:" + py_version + "-trixie",
            commands: [
                "pip install limnoria",
                "pip install -r requirements.txt",
                "export PLUGIN_NAME=$(echo $DRONE_REPO_NAME | sed 's/^Limnoria-//i')",
                "echo Set PLUGIN_NAME to $PLUGIN_NAME from $DRONE_REPO_NAME $DRONE_REPO_LINK",
                "ln -s $(pwd) $PLUGIN_NAME",
                "supybot-test -c $PLUGIN_NAME",
            ],
            environment: {
                [secret_name]: {
                    from_secret: secret_name
                }
                for secret_name in [
                    "AQICN_APIKEY",
                    "NUWEATHER_APIKEY_OPENWEATHERMAP",
                    "NUWEATHER_APIKEY_PIRATEWEATHER",
                    "NUWEATHER_APIKEY_WEATHERSTACK",
                ]
            }
        },
    ]
};

[
    # Reduced to oldest and latest supported to avoid API call spam
    supybot_test("3.9"),
    supybot_test("3.13"),
]
